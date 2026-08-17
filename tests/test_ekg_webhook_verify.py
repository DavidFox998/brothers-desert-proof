"""
TEMPORARY — EKG webhook alert verification test.

This file exists solely to exercise the on-failure webhook alert step in
.github/workflows/ekg-webhook-verify.yml.  It contains one test that
intentionally fails so CI triggers the alert path.

After the alert is confirmed to fire, this file is removed.
"""
import pytest


def test_force_failure_for_webhook_alert_verification():
    """
    Intentional forced failure — used only to verify the EKG webhook alert
    fires correctly in CI.  Remove this file once the alert is confirmed.
    """
    pytest.fail(
        "[WEBHOOK-VERIFY] This test fails on purpose to trigger the on-failure "
        "webhook alert step. If you see this in a regular test run, delete "
        "tests/test_ekg_webhook_verify.py — verification is complete."
    )
