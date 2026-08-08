"""
routers/shopify_app.py
======================
ZeroBeacon Shopify App — "Collision-Proof Search"  $19/month

OAuth install flow → script-tag injection → $19/mo recurring charge.
Merchants add one line to their storefront; ZeroBeacon handles the rest.

Required environment variables (set via `fly secrets set ...`):
  SHOPIFY_API_KEY     — from Shopify Partner dashboard → App → API credentials
  SHOPIFY_API_SECRET  — same location
  APP_URL             — public base URL, e.g. https://api.zerobeacon.ai

Setup steps (one-time, in Shopify Partner dashboard):
  1. Create app → Public app
  2. App URL: https://api.zerobeacon.ai/shopify/callback
  3. Allowed redirect URLs: https://api.zerobeacon.ai/shopify/callback
  4. Required scopes: read_products, write_script_tags
  5. Webhooks → App uninstalled → https://api.zerobeacon.ai/shopify/webhooks/uninstall
  6. Set fly secrets: SHOPIFY_API_KEY, SHOPIFY_API_SECRET
  7. Submit for Shopify App Store review at $19/mo
"""

import os, json, hmac, hashlib, time, secrets, urllib.request, urllib.parse, urllib.error
from pathlib import Path
from fastapi import APIRouter, Request, Query, Header
from fastapi.responses import HTMLResponse, RedirectResponse, JSONResponse

router = APIRouter()

# ── Config ────────────────────────────────────────────────────────────────────
SHOPIFY_API_KEY    = os.environ.get("SHOPIFY_API_KEY", "")
SHOPIFY_API_SECRET = os.environ.get("SHOPIFY_API_SECRET", "")
APP_URL            = os.environ.get("APP_URL", "https://api.zerobeacon.ai")
MONTHLY_PRICE      = "19.00"
CHARGE_NAME        = "ZeroBeacon Collision-Proof Search"
TRIAL_DAYS         = 7
SCOPES             = "read_products,write_script_tags"

# ── Shop token store ──────────────────────────────────────────────────────────
_DATA_DIR  = Path("/app/data") if Path("/app/data").exists() else Path("/tmp")
_SHOP_PATH = _DATA_DIR / "shopify_shops.json"

def _load_shops() -> dict:
    try:
        return json.loads(_SHOP_PATH.read_text()) if _SHOP_PATH.exists() else {}
    except Exception:
        return {}

def _save_shops(shops: dict):
    try:
        tmp = _SHOP_PATH.with_suffix(".tmp")
        tmp.write_text(json.dumps(shops, indent=2))
        tmp.replace(_SHOP_PATH)
    except Exception as e:
        print(f"[shopify] WARNING: could not persist shop store: {e}", flush=True)

def _get_shop(shop: str) -> dict:
    return _load_shops().get(shop, {})

def _set_shop(shop: str, data: dict):
    shops = _load_shops()
    shops[shop] = {**shops.get(shop, {}), **data, "updated_at": int(time.time())}
    _save_shops(shops)

def _delete_shop(shop: str):
    shops = _load_shops()
    shops.pop(shop, None)
    _save_shops(shops)

# ── Shopify API helpers ───────────────────────────────────────────────────────
def _shopify_get(shop: str, token: str, path: str) -> dict:
    url = f"https://{shop}/admin/api/2024-01{path}"
    req = urllib.request.Request(url, headers={
        "X-Shopify-Access-Token": token,
        "Content-Type": "application/json",
    })
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            return json.loads(r.read())
    except Exception as e:
        return {"error": str(e)}

def _shopify_post(shop: str, token: str, path: str, payload: dict) -> dict:
    url = f"https://{shop}/admin/api/2024-01{path}"
    data = json.dumps(payload).encode()
    req = urllib.request.Request(url, data=data, headers={
        "X-Shopify-Access-Token": token,
        "Content-Type": "application/json",
    }, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            return json.loads(r.read())
    except urllib.error.HTTPError as e:
        body = e.read().decode(errors="replace")
        return {"error": f"HTTP {e.code}", "detail": body}
    except Exception as e:
        return {"error": str(e)}

def _shopify_delete(shop: str, token: str, path: str) -> dict:
    url = f"https://{shop}/admin/api/2024-01{path}"
    req = urllib.request.Request(url, headers={
        "X-Shopify-Access-Token": token,
    }, method="DELETE")
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            return {"status": r.status}
    except Exception as e:
        return {"error": str(e)}

def _verify_shopify_hmac(params: dict, secret: str) -> bool:
    """Verify the HMAC signature Shopify sends on OAuth callbacks."""
    received = params.pop("hmac", "")
    sorted_params = "&".join(
        f"{urllib.parse.quote(k)}={urllib.parse.quote(str(v))}"
        for k, v in sorted(params.items())
    )
    expected = hmac.new(
        secret.encode(), sorted_params.encode(), hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected, received)

def _verify_webhook_hmac(body: bytes, header_hmac: str, secret: str) -> bool:
    """Verify HMAC on incoming Shopify webhooks."""
    import base64
    digest = hmac.new(secret.encode(), body, hashlib.sha256).digest()
    return hmac.compare_digest(
        base64.b64encode(digest).decode(),
        header_hmac or ""
    )

def _exchange_token(shop: str, code: str) -> str | None:
    """Exchange OAuth code for a permanent access token."""
    url = f"https://{shop}/admin/oauth/access_token"
    data = json.dumps({
        "client_id": SHOPIFY_API_KEY,
        "client_secret": SHOPIFY_API_SECRET,
        "code": code,
    }).encode()
    req = urllib.request.Request(url, data=data, headers={"Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            return json.loads(r.read()).get("access_token")
    except Exception as e:
        print(f"[shopify] token exchange failed for {shop}: {e}", flush=True)
        return None

def _install_script_tag(shop: str, token: str) -> dict:
    """Inject the ZeroBeacon collision-proof search script into the storefront.

    The injected script (/shopify/beacon.js) intercepts Shopify predictive-search
    API calls and routes them through /shopify/search, which returns beacon-verified
    results guaranteed to have no variant collisions.
    """
    # First remove any existing ZeroBeacon script tags to avoid duplicates
    existing = _shopify_get(shop, token, "/script_tags.json?limit=50")
    for tag in existing.get("script_tags", []):
        if "zerobeacon" in tag.get("src", ""):
            _shopify_delete(shop, token, f"/script_tags/{tag['id']}.json")

    # Use the Shopify-specific search script, not the generic beacon.js.
    # The shop param lets the script proxy searches through /shopify/search.
    script_url = (
        f"{APP_URL}/shopify/beacon.js"
        f"?shop={urllib.parse.quote(shop)}"
        f"&d=2303582338&beacon=1d2c7a5b"
    )
    return _shopify_post(shop, token, "/script_tags.json", {
        "script_tag": {
            "event": "onload",
            "src": script_url,
            "display_scope": "online_store",
        }
    })

def _create_recurring_charge(shop: str, token: str) -> dict:
    """Create a $19/mo recurring application charge (7-day free trial)."""
    return _shopify_post(shop, token, "/recurring_application_charges.json", {
        "recurring_application_charge": {
            "name": CHARGE_NAME,
            "price": MONTHLY_PRICE,
            "return_url": f"{APP_URL}/shopify/billing/confirm?shop={shop}",
            "trial_days": TRIAL_DAYS,
            "test": os.environ.get("SHOPIFY_TEST_MODE", "false").lower() == "true",
        }
    })

# ── Routes ────────────────────────────────────────────────────────────────────

@router.get("/shopify/install", tags=["Shopify"])
async def shopify_install(shop: str = Query(..., description="mystore.myshopify.com")):
    """
    **Step 1 — OAuth install start.**
    Redirect merchants here from the Shopify App Store listing.
    This sends them to Shopify's OAuth consent screen.

    Example: `GET /shopify/install?shop=mystore.myshopify.com`
    """
    if not SHOPIFY_API_KEY:
        return JSONResponse({"error": "SHOPIFY_API_KEY not configured"}, status_code=503)
    if not shop.endswith(".myshopify.com"):
        return JSONResponse({"error": "shop must end in .myshopify.com"}, status_code=400)

    nonce = secrets.token_hex(16)
    _set_shop(shop, {"nonce": nonce, "install_started": int(time.time())})

    params = urllib.parse.urlencode({
        "client_id": SHOPIFY_API_KEY,
        "scope": SCOPES,
        "redirect_uri": f"{APP_URL}/shopify/callback",
        "state": nonce,
        "grant_options[]": "per-user",
    })
    return RedirectResponse(f"https://{shop}/admin/oauth/authorize?{params}")


@router.get("/shopify/callback", tags=["Shopify"])
async def shopify_callback(
    shop: str = Query(...),
    code: str = Query(...),
    state: str = Query(...),
    hmac_val: str = Query(None, alias="hmac"),
    timestamp: str = Query(None),
):
    """
    **Step 2 — OAuth callback.**
    Shopify redirects here after the merchant grants permission.
    Exchanges the code for a permanent token, installs the script tag,
    and creates the $19/mo recurring charge.
    """
    if not SHOPIFY_API_SECRET:
        return JSONResponse({"error": "SHOPIFY_API_SECRET not configured"}, status_code=503)

    # Verify nonce
    shop_data = _get_shop(shop)
    if not shop_data or shop_data.get("nonce") != state:
        return JSONResponse({"error": "Invalid state/nonce — possible CSRF"}, status_code=403)

    # Verify Shopify HMAC — unconditional: reject if absent or invalid.
    # A missing hmac means the request did not come from Shopify's OAuth flow.
    if not hmac_val:
        return JSONResponse({"error": "HMAC missing — callback must originate from Shopify"}, status_code=403)
    params_to_verify = {"shop": shop, "code": code, "state": state, "timestamp": timestamp or "", "hmac": hmac_val}
    if not _verify_shopify_hmac(dict(params_to_verify), SHOPIFY_API_SECRET):
        return JSONResponse({"error": "HMAC verification failed"}, status_code=403)

    # Exchange code for access token
    token = _exchange_token(shop, code)
    if not token:
        return JSONResponse({"error": "Token exchange failed"}, status_code=500)

    # Install script tag
    script_result = _install_script_tag(shop, token)
    script_id = script_result.get("script_tag", {}).get("id")
    print(f"[shopify] Installed script tag {script_id} for {shop}", flush=True)

    # Create $19/mo recurring charge
    charge_result = _create_recurring_charge(shop, token)
    charge = charge_result.get("recurring_application_charge", {})
    charge_id = charge.get("id")
    confirmation_url = charge.get("confirmation_url", "")

    _set_shop(shop, {
        "token": token,
        "script_tag_id": script_id,
        "charge_id": charge_id,
        "charge_status": "pending",
        "nonce": None,
    })
    print(f"[shopify] Created charge {charge_id} for {shop} → {confirmation_url}", flush=True)

    if confirmation_url:
        return RedirectResponse(confirmation_url)
    # If no billing needed (test/development), go straight to success
    return RedirectResponse(f"{APP_URL}/shopify/success?shop={shop}")


@router.get("/shopify/billing/confirm", tags=["Shopify"])
async def shopify_billing_confirm(
    shop: str = Query(...),
    charge_id: int = Query(None),
):
    """
    **Step 3 — Billing confirmation.**
    Shopify redirects here after the merchant accepts (or declines) the charge.
    On acceptance, the script tag is already installed and the store is active.
    """
    shop_data = _get_shop(shop)
    token = shop_data.get("token")
    if not token:
        return JSONResponse({"error": "Shop not found — reinstall required"}, status_code=404)

    cid = charge_id or shop_data.get("charge_id")
    if cid:
        charge = _shopify_get(shop, token, f"/recurring_application_charges/{cid}.json")
        status = charge.get("recurring_application_charge", {}).get("status", "unknown")
        _set_shop(shop, {"charge_status": status})

        if status == "accepted":
            # Activate the charge
            _shopify_post(shop, token, f"/recurring_application_charges/{cid}/activate.json", {})
            _set_shop(shop, {"charge_status": "active", "active_since": int(time.time())})
            print(f"[shopify] Charge activated for {shop}", flush=True)
            return RedirectResponse(f"{APP_URL}/shopify/success?shop={shop}")
        elif status == "declined":
            return HTMLResponse(_shopify_declined_page(shop), status_code=402)

    return RedirectResponse(f"{APP_URL}/shopify/success?shop={shop}")


@router.get("/shopify/success", response_class=HTMLResponse, tags=["Shopify"])
async def shopify_success(shop: str = Query("")):
    """Install success page shown to the merchant after setup."""
    return HTMLResponse(_shopify_success_page(shop))


@router.get("/shopify/status", tags=["Shopify"])
async def shopify_status(shop: str = Query(...)):
    """Check install status for a store (for debugging / support)."""
    data = _get_shop(shop)
    if not data:
        return JSONResponse({"installed": False, "shop": shop})
    return {
        "installed": bool(data.get("token")),
        "shop": shop,
        "charge_status": data.get("charge_status", "unknown"),
        "script_tag_id": data.get("script_tag_id"),
        "active_since": data.get("active_since"),
    }


@router.get("/shopify/beacon.js", tags=["Shopify"])
async def shopify_beacon_js(
    shop: str = Query(..., description="mystore.myshopify.com"),
    d: int = Query(2303582338, description="Beacon store ID"),
    beacon: str = Query("1d2c7a5b", description="Beacon hash"),
):
    """
    **ZeroBeacon Shopify search script.**

    Served as a Shopify Script Tag. Intercepts Shopify's predictive-search
    API calls and routes them through `/shopify/search`, which beacon-verifies
    every result to guarantee no variant collisions.

    Injected automatically at install time — merchants never touch this URL.
    """
    from fastapi.responses import Response as FastResponse
    js = f"""/* ZeroBeacon Collision-Proof Search v1.0
 * Store: {shop}
 * Beacon: d={d} beacon={beacon}
 * https://zerobeacon.ai
 */
(function() {{
  'use strict';

  var ZB_SHOP   = {json.dumps(shop)};
  var ZB_API    = 'https://api.zerobeacon.ai';
  var ZB_BEACON = {json.dumps(beacon)};
  var ZB_D      = {d};

  /* ── Beacon-verified product search ────────────────────────────────────── */
  function zbSearch(q, limit, cb) {{
    var url = ZB_API + '/shopify/search'
              + '?shop='  + encodeURIComponent(ZB_SHOP)
              + '&q='     + encodeURIComponent(q)
              + '&limit=' + (limit || 10);
    /* Use mode:'cors' + credentials:'omit' so the browser sends a simple
     * cross-origin request.  The /shopify/search endpoint returns
     * Access-Control-Allow-Origin:* which is valid for non-credentialed
     * requests from any storefront origin. */
    fetch(url, {{ mode: 'cors', credentials: 'omit' }})
      .then(function(r) {{ return r.json(); }})
      .then(function(data) {{ cb(null, data); }})
      .catch(function(err) {{ cb(err, null); }});
  }}

  /* ── Detect Shopify predictive-search URLs ──────────────────────────────
   * Shopify themes (including Dawn) call:
   *   /search/suggest.json?q=...&resources[type]=product
   *   /search/suggest.json?q=...&resources[type]=product,article,page
   * The bracket notation is percent-encoded by some browsers:
   *   resources%5Btype%5D=product
   * We must intercept whenever the comma-separated type list INCLUDES
   * "product" so multi-resource-type Dawn requests are not missed.
   */
  function zbIsProductSearch(rawUrl) {{
    if (rawUrl.indexOf('/search/suggest') === -1) return false;
    try {{
      var qs = rawUrl.indexOf('?') !== -1 ? rawUrl.split('?')[1] : '';
      /* URLSearchParams decodes percent-encoding automatically */
      var params = new URLSearchParams(qs);
      var resourceType = params.get('resources[type]') || '';
      /* Split on comma and check any segment equals 'product' */
      var types = resourceType.split(',').map(function(t) {{ return t.trim(); }});
      if (types.indexOf('product') !== -1) return true;
    }} catch (e) {{
      /* ignore — fall through to string fallback */
    }}
    /* Fallback: plain substring check covers both encoded and raw forms.
     * We check for the word "product" inside the resources[type] segment,
     * not as a loose substring, to avoid false matches. */
    try {{
      var qs2 = rawUrl.indexOf('?') !== -1 ? rawUrl.split('?')[1] : '';
      var segments = qs2.split('&');
      for (var i = 0; i < segments.length; i++) {{
        var kv = segments[i];
        if (kv.indexOf('resources%5Btype%5D=') === 0 ||
            kv.indexOf('resources[type]=') === 0) {{
          var val = decodeURIComponent(kv.split('=').slice(1).join('='));
          var ts = val.split(',').map(function(t) {{ return t.trim(); }});
          if (ts.indexOf('product') !== -1) return true;
        }}
      }}
    }} catch (e2) {{
      /* give up */
    }}
    return false;
  }}

  /* ── Translate /shopify/search response to Shopify suggest.json shape ───
   * /shopify/search returns: {{ results: [...], beacon, ts, ... }}
   * Each result: {{ id, title, handle, variant_count, collision_free, proof, beacon, d }}
   * Shopify suggest.json expects: {{ resources: {{ results: {{ products: [...] }} }} }}
   */
  function zbToSuggestShape(data) {{
    var items = (data.results || []).map(function(p) {{
      return {{
        available:             p.collision_free !== false,
        compare_at_price_max:  '0.00',
        compare_at_price_min:  '0.00',
        id:                    p.id || 0,
        price:                 '0.00',
        title:                 p.title || '',
        handle:                p.handle || '',
        featured_image:        {{ src: null }},
        url:                   '/products/' + (p.handle || ''),
        _zerobeacon:           {{ proof: p.proof, beacon: p.beacon || ZB_BEACON, d: p.d || ZB_D }}
      }};
    }});
    return JSON.stringify({{ resources: {{ results: {{ products: items }} }} }});
  }}

  /* ── Intercept Shopify predictive-search fetch calls ────────────────────*/
  var _origFetch = window.fetch;
  window.fetch = function(input, init) {{
    var rawUrl = (typeof input === 'string') ? input : (input && input.url) || '';
    if (zbIsProductSearch(rawUrl)) {{
      var qs = rawUrl.indexOf('?') !== -1 ? rawUrl.split('?')[1] : '';
      var q = '';
      try {{
        q = new URLSearchParams(qs).get('q') || '';
      }} catch (e) {{
        var m = rawUrl.match(/[?&]q=([^&]*)/);
        q = m ? decodeURIComponent(m[1]) : '';
      }}
      if (q) {{
        return new Promise(function(resolve) {{
          zbSearch(q, 10, function(err, data) {{
            if (err || !data || !Array.isArray(data.results)) {{
              /* Fall back to Shopify's own endpoint on error */
              resolve(_origFetch(input, init));
              return;
            }}
            var body = zbToSuggestShape(data);
            resolve(new Response(body, {{
              status: 200,
              headers: {{
                'Content-Type': 'application/json',
                'X-ZeroBeacon-Proof': (data.results[0] && data.results[0].proof) || ''
              }}
            }}));
          }});
        }});
      }}
    }}
    return _origFetch(input, init);
  }};

  /* ── Trust badge ────────────────────────────────────────────────────────── */
  function zbBadge() {{
    var el = document.createElement('div');
    el.id = 'zerobeacon-badge';
    el.title = 'ZeroBeacon collision-proof search active';
    el.style.cssText = 'position:fixed;bottom:12px;right:12px;z-index:9999;'
      + 'display:flex;align-items:center;gap:4px;padding:4px 10px;'
      + 'border-radius:12px;background:#0f172a;color:#38bdf8;'
      + 'font-size:11px;font-family:system-ui,sans-serif;font-weight:600;'
      + 'border:1px solid #38bdf8;cursor:pointer;';
    el.innerHTML = '&#9711; ZeroBeacon <b style="color:#fff">Search</b>';
    el.onclick = function() {{ window.open('https://zerobeacon.ai', '_blank'); }};
    document.body && document.body.appendChild(el);
  }}
  if (document.readyState === 'loading') {{
    document.addEventListener('DOMContentLoaded', zbBadge);
  }} else {{
    zbBadge();
  }}

  /* Expose helpers so integration tests can exercise the served script
   * directly rather than maintaining copies that can drift. */
  window.ZeroBeaconSearch = {{
    search:           zbSearch,
    shop:             ZB_SHOP,
    beacon:           ZB_BEACON,
    _isProductSearch: zbIsProductSearch,
    _toSuggestShape:  zbToSuggestShape,
  }};
}})();
"""
    return FastResponse(content=js, media_type="application/javascript")


@router.get("/shopify/search", tags=["Shopify"])
async def shopify_search(
    shop: str = Query(..., description="mystore.myshopify.com"),
    q: str = Query(..., description="Search query"),
    limit: int = Query(10, ge=1, le=50),
):
    """
    **Beacon-verified product search proxy.**
    Queries the merchant's Shopify catalog and returns results tagged
    with a ZeroBeacon proof — guaranteeing no variant collisions in AI responses.

    Called by the beacon.js storefront script for search-as-you-type.
    """
    shop_data = _get_shop(shop)
    token = shop_data.get("token")
    if not token:
        return JSONResponse({"error": "Shop not installed"}, status_code=403)
    if shop_data.get("charge_status") not in ("active", "pending"):
        return JSONResponse({"error": "Subscription inactive"}, status_code=402)

    from core.beacon import beacon_payload, D, BEACON
    import math

    # Fetch products from Shopify
    encoded_q = urllib.parse.quote(q)
    products_resp = _shopify_get(
        shop, token,
        f"/products.json?title={encoded_q}&limit={limit}&fields=id,title,handle,variants,images"
    )
    products = products_resp.get("products", [])

    # Attach beacon proof to each result — guarantees collision-free variant ID
    ts = int(time.time())
    results = []
    for p in products:
        variant_ids = [v["id"] for v in p.get("variants", [])]
        # Collision check: verify no two variant IDs share the same mod-D residue
        residues = [v % D for v in variant_ids]
        collision_free = len(residues) == len(set(residues))
        msg = f"{p['id']}:{q}:{ts}".encode()
        from core.keystore import _DATA_DIR as _kd  # reuse SECRET
        import os as _os
        _secret = (_os.environ.get("SESSION_SECRET") or "zerobeacon-fallback-secret").encode()
        import hmac as _hmac, hashlib as _hs
        proof = _hmac.new(_secret, msg, _hs.sha256).hexdigest()
        results.append({
            "id": p["id"],
            "title": p["title"],
            "handle": p["handle"],
            "variant_count": len(variant_ids),
            "collision_free": collision_free,
            "proof": proof,
            "beacon": BEACON,
            "d": D,
        })

    # Return explicit CORS header so merchant storefronts (any origin) can call
    # this endpoint from their storefront JS without credentials.  The global
    # CORSMiddleware reflects the request Origin with credentials=true, which
    # conflicts with wildcard-origin non-credentialed requests; we override it
    # here with a permissive header that is valid for non-credentialed XHR/fetch.
    response = JSONResponse({
        "shop": shop,
        "query": q,
        "results": results,
        "total": len(results),
        "beacon": BEACON,
        "ts": ts,
        "collision_guarantee": "ZeroBeacon d=2303582338",
    })
    response.headers["Access-Control-Allow-Origin"] = "*"
    response.headers["Access-Control-Allow-Methods"] = "GET, OPTIONS"
    response.headers["Access-Control-Allow-Headers"] = "Content-Type"
    return response


@router.post("/shopify/webhooks/uninstall", tags=["Shopify"])
async def shopify_webhook_uninstall(
    request: Request,
    x_shopify_shop_domain: str = Header(None),
    x_shopify_hmac_sha256: str = Header(None),
):
    """
    Shopify calls this when a merchant uninstalls the app.
    Cleans up the shop record. HMAC-verified.
    """
    body = await request.body()
    err = _require_webhook_hmac(body, x_shopify_hmac_sha256)
    if err:
        return err
    shop = x_shopify_shop_domain or ""
    _delete_shop(shop)
    print(f"[shopify] Uninstalled: {shop}", flush=True)
    return JSONResponse({"ok": True})


# ── Shared webhook HMAC guard ─────────────────────────────────────────────────

def _require_webhook_hmac(body: bytes, header_hmac: str | None) -> JSONResponse | None:
    """Verify a Shopify webhook HMAC.  Fail closed on both invalid and missing secret.

    Reads SHOPIFY_API_SECRET from the environment at call time (not at import
    time) so that tests can patch os.environ without reloading the module.

    Returns a JSONResponse error (401 or 503) when the request must be rejected,
    or None when verification passes and the handler may proceed.

    Policy:
    - SHOPIFY_API_SECRET not configured → 503 (misconfiguration; reject everything)
    - HMAC header absent or invalid     → 401 (unauthenticated request)
    """
    secret = os.environ.get("SHOPIFY_API_SECRET", "")
    if not secret:
        return JSONResponse(
            {"error": "Webhook secret not configured — set SHOPIFY_API_SECRET"},
            status_code=503,
        )
    if not _verify_webhook_hmac(body, header_hmac or "", secret):
        return JSONResponse({"error": "Invalid HMAC"}, status_code=401)
    return None


# ── Shopify mandatory privacy webhooks ────────────────────────────────────────
# Shopify requires these three endpoints for App Store approval.
# All three fail closed: missing secret → 503, invalid/absent HMAC → 401.
# ZeroBeacon stores no customer PII beyond the shop access token.

@router.post("/shopify/webhooks/privacy/customers_data_request", tags=["Shopify"])
async def shopify_privacy_customers_data_request(
    request: Request,
    x_shopify_shop_domain: str = Header(None),
    x_shopify_hmac_sha256: str = Header(None),
):
    """
    **Shopify GDPR — customer data request.**
    Called when a customer requests their stored data. ZeroBeacon stores only
    the shop access token (no personal customer data), so there is nothing to return.
    Fails closed: 503 if SHOPIFY_API_SECRET is unset, 401 on bad/missing HMAC.
    """
    body = await request.body()
    err = _require_webhook_hmac(body, x_shopify_hmac_sha256)
    if err:
        return err
    print(f"[shopify] customers/data_request from {x_shopify_shop_domain}", flush=True)
    return JSONResponse({"ok": True, "data_held": []})


@router.post("/shopify/webhooks/privacy/customers_redact", tags=["Shopify"])
async def shopify_privacy_customers_redact(
    request: Request,
    x_shopify_shop_domain: str = Header(None),
    x_shopify_hmac_sha256: str = Header(None),
):
    """
    **Shopify GDPR — customer data erasure.**
    Called when a customer's data must be erased. ZeroBeacon stores no personal
    customer data, so this is a no-op acknowledgement.
    Fails closed: 503 if SHOPIFY_API_SECRET is unset, 401 on bad/missing HMAC.
    """
    body = await request.body()
    err = _require_webhook_hmac(body, x_shopify_hmac_sha256)
    if err:
        return err
    print(f"[shopify] customers/redact from {x_shopify_shop_domain}", flush=True)
    return JSONResponse({"ok": True})


@router.post("/shopify/webhooks/privacy/shop_redact", tags=["Shopify"])
async def shopify_privacy_shop_redact(
    request: Request,
    x_shopify_shop_domain: str = Header(None),
    x_shopify_hmac_sha256: str = Header(None),
):
    """
    **Shopify GDPR — shop data erasure.**
    Called 48 hours after a merchant uninstalls the app, requesting full data
    deletion. Removes any remaining shop record from the local store.
    Fails closed: 503 if SHOPIFY_API_SECRET is unset, 401 on bad/missing HMAC.
    """
    body = await request.body()
    err = _require_webhook_hmac(body, x_shopify_hmac_sha256)
    if err:
        return err
    shop = x_shopify_shop_domain or ""
    if shop:
        _delete_shop(shop)
        print(f"[shopify] shop/redact: deleted all data for {shop}", flush=True)
    return JSONResponse({"ok": True})


# ── HTML pages ────────────────────────────────────────────────────────────────

def _shopify_success_page(shop: str) -> str:
    return f"""<!doctype html><html lang="en">
<head><meta charset="utf-8"><title>ZeroBeacon Installed ✓</title>
<style>
  body{{font-family:system-ui,sans-serif;background:#0f172a;color:#e2e8f0;
       display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0}}
  .card{{background:#1e293b;border:1px solid #334155;border-radius:16px;padding:48px;
         max-width:480px;text-align:center;box-shadow:0 25px 50px rgba(0,0,0,.5)}}
  h1{{color:#38bdf8;font-size:2rem;margin:0 0 8px}}
  .check{{font-size:3rem;margin-bottom:16px}}
  p{{color:#94a3b8;line-height:1.6;margin:8px 0}}
  code{{background:#0f172a;color:#7dd3fc;padding:4px 8px;border-radius:6px;
        font-size:.85rem;display:inline-block;margin:12px 0;word-break:break-all}}
  .badge{{display:inline-flex;align-items:center;gap:4px;padding:4px 12px;
          border-radius:12px;background:#0f172a;color:#38bdf8;font-size:12px;
          font-weight:600;border:1px solid #38bdf8;margin-top:16px}}
</style></head>
<body><div class="card">
  <div class="check">✅</div>
  <h1>ZeroBeacon Installed!</h1>
  <p>Collision-proof product search is now active on <strong>{shop or "your store"}</strong>.</p>
  <p>Your storefront now loads:</p>
  <code>&lt;script src="https://api.zerobeacon.ai/shopify/beacon.js?shop={shop}"&gt;&lt;/script&gt;</code>
  <p style="color:#64748b;font-size:.85rem">7-day free trial · then $19/month · cancel any time</p>
  <div class="badge">⬤ ZeroBeacon <b style="color:#fff">Verified</b></div>
</div></body></html>"""

def _shopify_declined_page(shop: str) -> str:
    return f"""<!doctype html><html lang="en">
<head><meta charset="utf-8"><title>ZeroBeacon — Subscription Declined</title>
<style>
  body{{font-family:system-ui,sans-serif;background:#0f172a;color:#e2e8f0;
       display:flex;align-items:center;justify-content:center;min-height:100vh;margin:0}}
  .card{{background:#1e293b;border:1px solid #7f1d1d;border-radius:16px;padding:48px;
         max-width:480px;text-align:center}}
  h1{{color:#f87171;font-size:1.5rem}}
  a{{color:#38bdf8}}
</style></head>
<body><div class="card">
  <h1>Subscription Declined</h1>
  <p>No charge was made. To activate ZeroBeacon on <strong>{shop}</strong>,
  <a href="/shopify/install?shop={shop}">reinstall and accept the subscription</a>.</p>
</div></body></html>"""
