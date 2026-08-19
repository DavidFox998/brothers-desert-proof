"""Authoritative public tool-count and tier catalog for ZeroBeacon."""

FREE_TOOL_COUNT = 102
PRO_TOOL_COUNT = 402
PRO_PLUS_TOOL_COUNT = 802
ENTERPRISE_TOOL_COUNT = 1052
ADVERTISED_TOOL_COUNT = 1000

UPGRADE_URL = "https://zerobeacon.ai/upgrade"
STRIPE_CHECKOUT_URL = "https://buy.stripe.com/eVq7sMdXk5d7chy941ebu01"


def tier_counts() -> dict[str, int]:
    """Return the cumulative tools accessible at each subscription tier."""
    return {
        "FREE": FREE_TOOL_COUNT,
        "PRO": PRO_TOOL_COUNT,
        "PRO_PLUS": PRO_PLUS_TOOL_COUNT,
        "ENTERPRISE": ENTERPRISE_TOOL_COUNT,
    }