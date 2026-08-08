"""
Affiliate Checkout Router
=========================
Redirects buyers to the correct marketplace URL with the operator's affiliate
tag appended.  Accessible to FREE tier because it drives revenue for the
operator, not the caller.

Supported markets and their env-var affiliate credentials:
  amazon   → AMAZON_AFFILIATE_TAG   (Associates tag, e.g. "zerobeacon-20")
  ebay     → EBAY_CAMPAIGN_ID       (EPN campaign ID, e.g. "5338722557")
  walmart  → WALMART_PUBLISHER_ID   (CJ Publisher ID, e.g. "8031003")
  etsy     → ETSY_AFFILIATE_ID      (Awin/Etsy affiliate ID, e.g. "1234567")
  target   → TARGET_AFFILIATE_ID    (Impact affiliate SID)
  bestbuy  → BESTBUY_AFFILIATE_ID   (CJ affiliate tag)

Redirect log format (stdout, one line per click):
  AFFILIATE_REDIRECT market=<market> product=<product> url=<url> ts=<unix_ts>
"""

import logging
import os
import time
import urllib.parse

from fastapi import APIRouter, Query
from fastapi.responses import RedirectResponse, JSONResponse

router = APIRouter()
logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# In-memory redirect counters — reset on restart, enough for live traffic view
# ---------------------------------------------------------------------------

_redirect_counts: dict[str, int] = {}

# ---------------------------------------------------------------------------
# Affiliate config — read from env vars at request time so rotating tags
# (or adding new tags) doesn't require a restart.
# ---------------------------------------------------------------------------

def _cfg(key: str) -> str:
    """Return env-var value or empty string."""
    return os.environ.get(key, "")


MARKET_BUILDERS: dict[str, "callable"] = {}


def _build_amazon(product: str) -> str | None:
    tag = _cfg("AMAZON_AFFILIATE_TAG")
    if not tag:
        return None
    q = urllib.parse.quote_plus(product)
    return f"https://www.amazon.com/s?k={q}&tag={urllib.parse.quote(tag)}"


def _build_ebay(product: str) -> str | None:
    campaign = _cfg("EBAY_CAMPAIGN_ID")
    if not campaign:
        return None
    q = urllib.parse.quote_plus(product)
    return (
        f"https://www.ebay.com/sch/i.html?_nkw={q}"
        f"&mkcid=1&mkrid=711-53200-19255-0&siteid=0"
        f"&campid={urllib.parse.quote(campaign)}&customid=zb&toolid=10001&mkevt=1"
    )


def _build_walmart(product: str) -> str | None:
    pub_id = _cfg("WALMART_PUBLISHER_ID")
    if not pub_id:
        return None
    q = urllib.parse.quote_plus(product)
    return (
        f"https://www.walmart.com/search?q={q}"
        f"&wmlspartner={urllib.parse.quote(pub_id)}"
    )


def _build_etsy(product: str) -> str | None:
    aff_id = _cfg("ETSY_AFFILIATE_ID")
    if not aff_id:
        return None
    q = urllib.parse.quote_plus(product)
    return (
        f"https://www.etsy.com/search?q={q}"
        f"&utm_source=awin&utm_medium=affiliates&awc={urllib.parse.quote(aff_id)}"
    )


def _build_target(product: str) -> str | None:
    aff_id = _cfg("TARGET_AFFILIATE_ID")
    if not aff_id:
        return None
    q = urllib.parse.quote_plus(product)
    return (
        f"https://www.target.com/s?searchTerm={q}"
        f"&afid={urllib.parse.quote(aff_id)}"
    )


def _build_bestbuy(product: str) -> str | None:
    aff_tag = _cfg("BESTBUY_AFFILIATE_ID")
    if not aff_tag:
        return None
    q = urllib.parse.quote_plus(product)
    return (
        f"https://www.bestbuy.com/site/searchpage.jsp?st={q}"
        f"&ref={urllib.parse.quote(aff_tag)}"
    )


_BUILDERS = {
    "amazon":  _build_amazon,
    "ebay":    _build_ebay,
    "walmart": _build_walmart,
    "etsy":    _build_etsy,
    "target":  _build_target,
    "bestbuy": _build_bestbuy,
}

SUPPORTED_MARKETS = list(_BUILDERS.keys())


# ---------------------------------------------------------------------------
# Endpoint
# ---------------------------------------------------------------------------

@router.get(
    "/checkout",
    summary="Affiliate checkout redirect",
    description=(
        "[Affiliate][FREE] Route a product search to the correct marketplace "
        "with the operator's affiliate tag.  Returns a 302 redirect.  "
        "Supported markets: amazon, ebay, walmart, etsy, target, bestbuy.  "
        "FREE tier — no API key required."
    ),
    tags=["Affiliate"],
    response_class=RedirectResponse,
    responses={
        302: {"description": "Redirect to marketplace with affiliate tag"},
        400: {"description": "Missing or unsupported market"},
        503: {"description": "Affiliate tag not configured for this market"},
    },
)
def checkout(product: str, market: str = "amazon"):
    """
    Redirect to a marketplace URL with the operator's affiliate tag.

    - **product**: search term or product name (URL-encoded automatically)
    - **market**: one of amazon | ebay | walmart | etsy | target | bestbuy
    """
    market = market.lower().strip()

    if market not in _BUILDERS:
        return JSONResponse(
            status_code=400,
            content={
                "error": f"Unsupported market '{market}'",
                "supported": SUPPORTED_MARKETS,
            },
        )

    url = _BUILDERS[market](product)

    if url is None:
        env_keys = {
            "amazon":  "AMAZON_AFFILIATE_TAG",
            "ebay":    "EBAY_CAMPAIGN_ID",
            "walmart": "WALMART_PUBLISHER_ID",
            "etsy":    "ETSY_AFFILIATE_ID",
            "target":  "TARGET_AFFILIATE_ID",
            "bestbuy": "BESTBUY_AFFILIATE_ID",
        }
        return JSONResponse(
            status_code=503,
            content={
                "error": f"Affiliate tag not configured for market '{market}'",
                "action": f"Set the {env_keys.get(market, 'affiliate')} environment variable",
            },
        )

    ts = int(time.time())
    # Structured log line — parseable by Fly.io log drains / grep
    logger.info(
        "AFFILIATE_REDIRECT market=%s product=%s url=%s ts=%d",
        market, product, url, ts,
    )

    # Increment in-memory counter for this market
    _redirect_counts[market] = _redirect_counts.get(market, 0) + 1

    return RedirectResponse(url=url, status_code=302)


@router.get(
    "/checkout/markets",
    summary="List supported affiliate markets",
    description=(
        "[Affiliate][FREE] Returns the list of supported markets and whether "
        "each affiliate tag is currently configured.  Pass ?include_stats=true "
        "to also include the live redirect count for each market."
    ),
    tags=["Affiliate"],
)
def checkout_markets(include_stats: bool = False):
    """
    Inspect which affiliate markets are active (tag configured) vs unconfigured.

    - **include_stats**: when true, each market entry also includes a
      ``redirect_count`` field with the number of redirects since last restart.
    """
    env_keys = {
        "amazon":  "AMAZON_AFFILIATE_TAG",
        "ebay":    "EBAY_CAMPAIGN_ID",
        "walmart": "WALMART_PUBLISHER_ID",
        "etsy":    "ETSY_AFFILIATE_ID",
        "target":  "TARGET_AFFILIATE_ID",
        "bestbuy": "BESTBUY_AFFILIATE_ID",
    }
    markets = {}
    for market, env_key in env_keys.items():
        configured = bool(os.environ.get(env_key, ""))
        entry: dict = {
            "configured": configured,
            "env_var": env_key,
        }
        if include_stats:
            entry["redirect_count"] = _redirect_counts.get(market, 0)
        markets[market] = entry
    configured_count = sum(1 for m in markets.values() if m["configured"])
    return {
        "markets": markets,
        "configured_count": configured_count,
        "total": len(markets),
    }


@router.get(
    "/affiliate/stats",
    summary="Live redirect counts per market",
    description=(
        "[Affiliate][FREE] Returns the number of affiliate redirects recorded "
        "per market since the server last started.  Counters are in-memory and "
        "reset on restart.  No authentication required."
    ),
    tags=["Affiliate"],
)
def affiliate_stats():
    """
    In-memory per-market redirect counters.

    Returns the redirect count for every supported market since the last
    server restart.  Markets with zero redirects are included so the full
    picture is always visible.
    """
    stats = {
        market: _redirect_counts.get(market, 0)
        for market in SUPPORTED_MARKETS
    }
    total = sum(stats.values())
    return {
        "redirect_counts": stats,
        "total_redirects": total,
        "note": "Counters reset on server restart.",
    }


# ---------------------------------------------------------------------------
# Affiliate tag config — env var name → description
# ---------------------------------------------------------------------------

_AFFILIATE_ENV_VARS: dict[str, dict] = {
    "AMAZON_AFFILIATE_TAG":  {"market": "amazon",  "description": "Amazon Associates tag (e.g. zerobeacon-20)"},
    "EBAY_CAMPAIGN_ID":      {"market": "ebay",    "description": "eBay Partner Network campaign ID"},
    "WALMART_PUBLISHER_ID":  {"market": "walmart", "description": "CJ Publisher ID for Walmart"},
    "ETSY_AFFILIATE_ID":     {"market": "etsy",    "description": "Awin/Etsy affiliate ID"},
    "TARGET_AFFILIATE_ID":   {"market": "target",  "description": "Impact affiliate SID for Target"},
    "BESTBUY_AFFILIATE_ID":  {"market": "bestbuy", "description": "CJ affiliate tag for Best Buy"},
}


def _mask(value: str) -> str:
    """Return a masked representation: first 3 chars + asterisks + last 2 chars.

    For short values (≤5 chars) the entire value is masked with asterisks so
    leaking the length is the only risk, not the content.
    """
    if len(value) <= 5:
        return "*" * len(value)
    return value[:3] + "*" * (len(value) - 5) + value[-2:]


@router.get(
    "/affiliate/config",
    summary="View affiliate tag configuration (admin)",
    description=(
        "[Affiliate][ADMIN] Returns the current value of every affiliate env var "
        "with the value masked (first 3 + last 2 chars visible).  "
        "Protected by ADMIN_SECRET query parameter.  "
        "Use this to confirm a tag rotation took effect without redeploying."
    ),
    tags=["Affiliate"],
    responses={
        200: {"description": "Affiliate tag configuration (values masked)"},
        403: {"description": "Missing or invalid admin_secret"},
    },
)
def affiliate_config(
    admin_secret: str = Query(
        default="",
        description="Value of the ADMIN_SECRET environment variable",
        alias="admin_secret",
    ),
):
    """
    Admin endpoint: inspect all affiliate env var values (masked).

    Pass ?admin_secret=<value> matching the ADMIN_SECRET env var.
    Returns each var's env name, market, description, whether it is set,
    and its masked value (first 3 chars + *** + last 2 chars).

    To rotate a tag without redeploying, run:
        fly secrets set AMAZON_AFFILIATE_TAG=<new-tag> --app zerobeacon-mf-1000
    The new value takes effect on the next request (env vars are read at
    request time, not at startup).
    """
    expected = os.environ.get("ADMIN_SECRET", "")
    if not expected:
        logger.warning(
            "[admin] /affiliate/config called but ADMIN_SECRET is not set — "
            "endpoint is permanently disabled until ADMIN_SECRET is configured "
            "(fly secrets set ADMIN_SECRET=<value>). All callers rejected with 403."
        )
        return JSONResponse({"error": "forbidden"}, status_code=403)

    if admin_secret != expected:
        return JSONResponse({"error": "forbidden"}, status_code=403)

    config: dict = {}
    for env_key, meta in _AFFILIATE_ENV_VARS.items():
        raw = os.environ.get(env_key, "")
        config[env_key] = {
            "market":      meta["market"],
            "description": meta["description"],
            "set":         bool(raw),
            "value":       _mask(raw) if raw else None,
        }

    configured_count = sum(1 for v in config.values() if v["set"])
    return {
        "affiliate_tags":    config,
        "configured_count":  configured_count,
        "total":             len(config),
        "note": (
            "Values are masked. To rotate a tag without redeploying: "
            "fly secrets set <ENV_VAR>=<new-value> --app zerobeacon-mf-1000"
        ),
    }
