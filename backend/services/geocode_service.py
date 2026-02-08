from typing import Optional
import httpx

def _pick_city(address: dict) -> Optional[str]:
    return (
        address.get("city")
        or address.get("town")
        or address.get("village")
        or address.get("municipality")
        or address.get("county")
    )

async def reverse_geocode(lat: float, lng: float) -> Optional[str]:
    url = "https://nominatim.openstreetmap.org/reverse"
    params = {
        "format": "jsonv2",
        "lat": lat,
        "lon": lng,
        "zoom": 12,
        "addressdetails": 1,
    }
    headers = {"User-Agent": "LandmarkIdentify/1.0"}

    async with httpx.AsyncClient(timeout=10, headers=headers) as client:
        r = await client.get(url, params=params)
        if r.status_code != 200:
            return None
        data = r.json()

    address = data.get("address", {}) or {}
    return _pick_city(address)
