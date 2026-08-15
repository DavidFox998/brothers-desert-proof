"""
Playwright browser tests for the /brain/heartbeat EKG canvas page.

These tests load the page in a real Chromium browser and verify:
  - The <canvas id="c"> element has non-zero rendered width and height.
  - No JavaScript console errors are thrown within the first 3 seconds
    (the time required for at least one full beat cycle to fire).

Run locally against a live server:
    PLAYWRIGHT_BASE_URL=http://localhost:8000 pytest tests/test_heartbeat_playwright.py -v

Run against production:
    PLAYWRIGHT_BASE_URL=https://zerobeacon.ai pytest tests/test_heartbeat_playwright.py -v

In CI the workflow starts a local uvicorn server and sets PLAYWRIGHT_BASE_URL
automatically, so all checks run without requiring a deployed instance.

Skipped entirely when PLAYWRIGHT_BASE_URL is not set (safe for dev environments
that do not have Playwright browsers installed).
"""

import os
import time
import pytest

_base_url = os.getenv("PLAYWRIGHT_BASE_URL", "").rstrip("/")
_skip = pytest.mark.skipif(
    not _base_url,
    reason="PLAYWRIGHT_BASE_URL not set — skipping Playwright EKG canvas tests",
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _heartbeat_url() -> str:
    return f"{_base_url}/brain/heartbeat"


# ---------------------------------------------------------------------------
# Canvas geometry — non-zero width and height
# ---------------------------------------------------------------------------

@_skip
def test_canvas_nonzero_width(page):  # page fixture from pytest-playwright
    """Canvas must have a rendered width > 0 in a real browser."""
    page.goto(_heartbeat_url(), wait_until="networkidle")
    # Allow the beat loop one full cycle (200 ms) to start and resize the canvas.
    page.wait_for_timeout(400)
    rect = page.evaluate(
        """() => {
            const c = document.getElementById('c');
            if (!c) return null;
            return c.getBoundingClientRect();
        }"""
    )
    assert rect is not None, (
        "/brain/heartbeat: canvas#c not found in the live DOM"
    )
    assert rect["width"] > 0, (
        f"/brain/heartbeat: canvas rendered width is {rect['width']} — "
        "canvas is not visible or has zero width (layout/CSS regression?)"
    )


@_skip
def test_canvas_nonzero_height(page):
    """Canvas must have a rendered height > 0 in a real browser."""
    page.goto(_heartbeat_url(), wait_until="networkidle")
    page.wait_for_timeout(400)
    rect = page.evaluate(
        """() => {
            const c = document.getElementById('c');
            if (!c) return null;
            return c.getBoundingClientRect();
        }"""
    )
    assert rect is not None, (
        "/brain/heartbeat: canvas#c not found in the live DOM"
    )
    assert rect["height"] > 0, (
        f"/brain/heartbeat: canvas rendered height is {rect['height']} — "
        "canvas is not visible or has zero height (layout/CSS regression?)"
    )


@_skip
def test_canvas_pixel_buffer_nonzero(page):
    """canvas.width and canvas.height (pixel buffer) must both be > 0 after DPR scaling."""
    page.goto(_heartbeat_url(), wait_until="networkidle")
    # resizeCanvas() fires synchronously on load; wait one beat for good measure.
    page.wait_for_timeout(400)
    dims = page.evaluate(
        """() => {
            const c = document.getElementById('c');
            if (!c) return null;
            return { width: c.width, height: c.height };
        }"""
    )
    assert dims is not None, (
        "/brain/heartbeat: canvas#c not found in the live DOM"
    )
    assert dims["width"] > 0, (
        f"/brain/heartbeat: canvas.width (pixel buffer) = {dims['width']} — "
        "resizeCanvas() may not have fired or DPR scaling produced 0"
    )
    assert dims["height"] > 0, (
        f"/brain/heartbeat: canvas.height (pixel buffer) = {dims['height']} — "
        "resizeCanvas() may not have fired or DPR scaling produced 0"
    )


# ---------------------------------------------------------------------------
# No JS console errors within the first 3 seconds
# ---------------------------------------------------------------------------

@_skip
def test_no_js_console_errors_in_first_3s(page):
    """No JS console errors (level='error') must appear within the first 3 seconds.

    A syntax error, bad selector, or uncaught exception in draw()/beat() would
    surface here and fail the test before it reaches users.
    """
    errors: list[str] = []

    def _capture(msg):
        if msg.type == "error":
            errors.append(msg.text)

    page.on("console", _capture)

    # Also catch uncaught page exceptions (unhandled promise rejections, etc.)
    uncaught: list[str] = []

    def _capture_exc(exc):
        uncaught.append(str(exc))

    page.on("pageerror", _capture_exc)

    page.goto(_heartbeat_url(), wait_until="domcontentloaded")

    # Wait 3 seconds — enough for ≥15 beat() cycles (200 ms each).
    page.wait_for_timeout(3000)

    assert not errors, (
        f"/brain/heartbeat produced {len(errors)} JS console error(s) within 3 s:\n"
        + "\n".join(f"  • {e}" for e in errors)
    )
    assert not uncaught, (
        f"/brain/heartbeat produced {len(uncaught)} uncaught JS exception(s) within 3 s:\n"
        + "\n".join(f"  • {e}" for e in uncaught)
    )


# ---------------------------------------------------------------------------
# Beat loop is actually firing (not silently frozen)
# ---------------------------------------------------------------------------

@_skip
def test_beat_loop_advances_tick(page):
    """The internal tick counter must increase after 1 second, proving setInterval runs."""
    page.goto(_heartbeat_url(), wait_until="domcontentloaded")
    tick_before = page.evaluate("() => typeof tick !== 'undefined' ? tick : -1")
    page.wait_for_timeout(1200)
    tick_after = page.evaluate("() => typeof tick !== 'undefined' ? tick : -1")
    assert tick_after > tick_before, (
        f"/brain/heartbeat: tick counter did not advance after 1.2 s "
        f"(before={tick_before}, after={tick_after}) — beat loop may be frozen"
    )
