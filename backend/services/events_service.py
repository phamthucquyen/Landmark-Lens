import os

import httpx

from schemas.identify import EventSuggestion
from services.cache import get as cache_get, set as cache_set

TICKETMASTER_URL = "https://app.ticketmaster.com/discovery/v2/events.json"


async def get_nearby_events(
    lat: float,
    lng: float,
    radius_km: int = 20,
    max_results: int = 6,
) -> list[EventSuggestion]:
    api_key = os.getenv("TICKETMASTER_API_KEY")
    if not api_key:
        return []

    cache_key = f"events:{round(lat,4)}:{round(lng,4)}:{radius_km}"
    cached = cache_get(cache_key)
    if cached:
        return cached

    params = {
        "apikey": api_key,
        "latlong": f"{lat},{lng}",
        "radius": radius_km,
        "unit": "km",
        "size": max_results,
        "sort": "date,asc",
    }

    async with httpx.AsyncClient(timeout=8.0) as client:
        resp = await client.get(TICKETMASTER_URL, params=params)
        resp.raise_for_status()
        data = resp.json()

    events_raw = data.get("_embedded", {}).get("events", [])
    events: list[EventSuggestion] = []

    for item in events_raw:
        venue = None
        address = None
        venues = item.get("_embedded", {}).get("venues", [])
        if venues:
            venue = venues[0].get("name")
            addr1 = (venues[0].get("address") or {}).get("line1")
            city = (venues[0].get("city") or {}).get("name")
            state = (venues[0].get("state") or {}).get("name")
            parts = [p for p in [addr1, city, state] if p]
            address = ", ".join(parts) if parts else None

        date_time = (item.get("dates", {}).get("start", {}) or {}).get("dateTime")
        distance = item.get("distance")
        distance_m = int(float(distance) * 1000) if distance is not None else None

        classifications = item.get("classifications") or []
        category = None
        if classifications:
            segment = (classifications[0].get("segment") or {}).get("name")
            category = segment

        events.append(
            EventSuggestion(
                name=item.get("name", "Event"),
                start_time=date_time,
                venue=venue,
                address=address,
                distance_meters=distance_m,
                category=category,
                url=item.get("url"),
            )
        )

    cache_set(cache_key, events, ttl_seconds=60 * 10)
    return events
