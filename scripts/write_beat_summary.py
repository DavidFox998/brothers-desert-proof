#!/usr/bin/env python3
"""Parse a pytest-json-report file for the cold-start beat-rate test and emit
a GitHub Actions job-summary Markdown card.

Usage:
    python3 scripts/write_beat_summary.py <report_path> [--heading <title>]

Arguments:
    report_path   Path to the pytest JSON report produced with
                  `--json-report --json-report-file=<path>`.
    --heading     Card heading prefix (default: "Cold-Start Beat-Rate").

Environment:
    GITHUB_STEP_SUMMARY   When set (as in a GHA runner), the card is also
                          appended to the step-summary file.

Exit codes:
    0   Always (the step runs with `if: always()` and must not block CI
        just because a summary cannot be written).
"""

import argparse
import json
import os
import re
import sys


HEARTBEAT_URL = "https://zerobeacon.ai/brain/heartbeat"


def build_card(report_path: str, heading: str = "Cold-Start Beat-Rate") -> str:
    """Return a Markdown summary card string.  Never raises."""
    try:
        with open(report_path) as f:
            report = json.load(f)
    except Exception as e:  # noqa: BLE001
        return (
            f"## ⚠️ {heading} — Report Unavailable\n\n"
            f"Could not read `{report_path}`: {e}\n"
        )

    tests = report.get("tests", [])
    target = next(
        (t for t in tests if "cold_start" in t.get("nodeid", "")), None
    )

    if target is None:
        return (
            f"## ⚠️ {heading} — Test Not Found\n\n"
            "The `test_beat_fires_at_200ms_rate_cold_start` test was not "
            "found in the JSON report.\n"
        )

    passed = target.get("outcome") == "passed"

    # Structured measurements emitted via record_property().
    # pytest-json-report stores them as [[key, value], ...] in user_properties.
    props = dict(target.get("user_properties", []))
    ticks_fired = props.get("ticks_fired")
    tick_start  = props.get("tick_start")
    tick_end    = props.get("tick_end")
    obs_window  = props.get("observation_window_s", 2)
    required    = props.get("required_ticks", 5)

    # Fallback: if the test crashed before record_property ran, parse longrepr.
    if ticks_fired is None and not passed and "call" in target:
        longrepr = str(target["call"].get("longrepr", ""))
        m = re.search(r"only (\d+) beat", longrepr)
        if m:
            ticks_fired = int(m.group(1))

    status_icon = "✅" if passed else "❌"
    status_text = "PASSED" if passed else "FAILED"

    if ticks_fired is not None:
        ticks_display = f"{ticks_fired} / {required} required"
    else:
        ticks_display = "unknown"

    tick_detail = ""
    if tick_start is not None and tick_end is not None:
        tick_detail = f" (tick counter: {tick_start} → {tick_end})"

    lines = [
        f"## {status_icon} {heading} — {status_text}",
        "",
        "| Metric | Value |",
        "| --- | --- |",
        f"| Ticks fired | `{ticks_display}`{tick_detail} |",
        f"| Observation window | `{obs_window} seconds` |",
        f"| Required rate | `≥{required} ticks at 200 ms intervals` |",
        f"| Live heartbeat | [{HEARTBEAT_URL}]({HEARTBEAT_URL}) |",
        "",
    ]

    if not passed and ticks_fired is not None:
        lines.append(
            f"> **Shortfall:** only `{ticks_fired}/{required}` required ticks fired "
            f"in the {obs_window}-second cold-start window. "
            "The 200 ms `setInterval` beat loop may have regressed or the VM "
            "is waking too slowly after `auto_stop`."
        )
        lines.append("")

    return "\n".join(lines)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("report_path", help="Path to pytest JSON report")
    parser.add_argument(
        "--heading",
        default="Cold-Start Beat-Rate",
        help="Card heading prefix (default: 'Cold-Start Beat-Rate')",
    )
    args = parser.parse_args()

    card = build_card(args.report_path, heading=args.heading)
    print(card)

    summary_file = os.environ.get("GITHUB_STEP_SUMMARY", "")
    if summary_file:
        with open(summary_file, "a") as fh:
            fh.write(card)


if __name__ == "__main__":
    main()
