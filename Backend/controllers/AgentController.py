import json
import re
from typing import Optional
from bson import ObjectId
from fastapi import HTTPException

from config.database import (
    plant_collection, inverter_collection, sensor_collection,
    alert_collection, overview_collection, devices_collection,
    energy_logs_collection
)
from utils.gemini_utils import generate_content

# ─────────────────────────────────────────────
# Gemini Prompt Builder
# ─────────────────────────────────────────────
SYSTEM_PROMPT = """
You are an AI assistant for a Solar Plant Monitoring System.
Analyse the user's command and respond with a single JSON object.

Possible actions:
1. "navigate"  – user wants to open a page (list or a specific entity detail)
2. "query"     – user wants to know information/stats from the database
3. "action"    – user wants to create, delete, or modify something

Possible routes for navigate:
  /                   → Dashboard
  /plants             → All plants list
  /plants/:id         → Specific plant detail (extract name/index as params.id)
  /inverters          → All inverters list
  /inverters/:id      → Specific inverter detail (extract name/index as params.id)
  /sensors            → All sensors list
  /sensors/:id        → Specific sensor detail (extract name/index as params.id)
  /reports            → Reports & Exports

Possible query_type values for query:
  energy_today        – today's energy production
  energy_period       – energy for monthly/yearly/lifetime (use params.period)
  net_zero            – CO2 reduced, coal saved, trees planted
  plants_status       – plant count summary (active, alert, expired, etc.)
  plants_list         – list all plants with status & generation
  plant_detail        – one plant by name/id (use params.id)
  inverters_list      – list all inverters
  inverter_detail     – one inverter by name/id (use params.id)
  sensors_list        – list all sensors
  sensor_detail       – one sensor by name/id (use params.id)
  alerts_list         – list all current alerts
  alerts_count        – just the number of active alerts
  devices_summary     – device count summary (MFM, WFM, SLMS, Inverters)

Possible action_type values for action:
  create_alert        – create a new alert (params: plant_id, device_id, device_name, alert_name, severity, message, status)
  delete_alert        – delete an alert (params.id = alert id)
  create_export       – create an export record

Return ONLY a JSON object, with no markdown or explanation. Use this schema:
{
  "action": "navigate" | "query" | "action",
  "route": "/inverters/:id",
  "query_type": "inverter_detail",
  "action_type": "create_alert",
  "params": { "id": "inverter name or index", "period": "monthly" },
  "message": "Short human-readable summary of what you're doing"
}

Rules:
- Only include keys relevant to the chosen action type.
- For navigate with a specific entity, set route as the path WITH :id literal and put the extracted name/number in params.id.
- If the command is ambiguous or unrecognised, return: {"action": "unknown", "message": "..."}.
"""

def build_prompt(user_text: str) -> str:
    return f"{SYSTEM_PROMPT}\n\nUser command: \"{user_text}\""


# ─────────────────────────────────────────────
# Helper: Resolve entity name/number → _id
# ─────────────────────────────────────────────
async def resolve_entity_id(collection, name_hint: str, name_field: str = "device_name") -> Optional[str]:
    """
    Try to find a document matching name_hint (case-insensitive) in name_field.
    Also tries 'plant_name' and 'sensor_type' as fallbacks.
    Returns the string _id if found, else None.
    """
    hint = name_hint.lower().strip()
    # Try exact/partial match on multiple name fields
    for field in [name_field, "plant_name", "name", "sensor_type", "alert_name"]:
        doc = await collection.find_one({field: {"$regex": hint, "$options": "i"}})
        if doc:
            return str(doc["_id"])
    return None


# ─────────────────────────────────────────────
# Query Handlers
# ─────────────────────────────────────────────
async def handle_query(query_type: str, params: dict) -> dict:
    """Fetch data from MongoDB based on query_type and return a response dict."""

    # ── energy_today ──
    if query_type == "energy_today":
        overview = await overview_collection.find_one({"type": "dashboard_stats"})
        if not overview:
            return {"action": "query", "message": "No energy data available."}
        ep = overview.get("energyProduction", {})
        return {
            "action": "query",
            "data": ep,
            "message": f"Today's energy production is {ep.get('todayKwh', 'N/A')} "
                       f"({ep.get('percentage', 0)}% of capacity). "
                       f"Total production: {ep.get('totalProduction', 'N/A')} / "
                       f"Total capacity: {ep.get('totalCapacity', 'N/A')}."
        }

    # ── energy_period ──
    elif query_type == "energy_period":
        from datetime import datetime
        period = params.get("period", "monthly")
        now = datetime.now()
        if period == "monthly":
            pipeline = [
                {"$match": {"year": now.year, "month": now.month}},
                {"$group": {"_id": None, "total": {"$sum": "$kwh"}}},
            ]
            label = f"{now.strftime('%B %Y')}"
        elif period == "yearly":
            pipeline = [
                {"$match": {"year": now.year}},
                {"$group": {"_id": None, "total": {"$sum": "$kwh"}}},
            ]
            label = str(now.year)
        else:
            pipeline = [{"$group": {"_id": None, "total": {"$sum": "$kwh"}}}]
            label = "Lifetime"

        cursor = energy_logs_collection.aggregate(pipeline)
        result = await cursor.to_list(length=1)
        total = round(result[0]["total"], 2) if result else 0
        return {
            "action": "query",
            "data": {"period": label, "total_kwh": total},
            "message": f"{label} total energy generation: {total} kWh."
        }

    # ── net_zero ──
    elif query_type == "net_zero":
        overview = await overview_collection.find_one({"type": "dashboard_stats"})
        if not overview:
            return {"action": "query", "message": "No net-zero data available."}
        nz = overview.get("netZero", {})
        return {
            "action": "query",
            "data": nz,
            "message": f"Net-zero stats → CO₂ reduced: {nz.get('co2Reduced','N/A')}, "
                       f"Coal saved: {nz.get('coalSaved','N/A')}, "
                       f"Trees planted equivalent: {nz.get('treesPlanted','N/A')}."
        }

    # ── plants_status ──
    elif query_type == "plants_status":
        overview = await overview_collection.find_one({"type": "dashboard_stats"})
        if not overview:
            return {"action": "query", "message": "No plant status data available."}
        ps = overview.get("plantsStatus", {})
        return {
            "action": "query",
            "data": ps,
            "message": f"Total plants: {ps.get('totalPlants',0)}. "
                       f"Active: {ps.get('active',0)}, Alert: {ps.get('alert',0)}, "
                       f"Partially active: {ps.get('partiallyActive',0)}, Expired: {ps.get('expired',0)}."
        }

    # ── plants_list ──
    elif query_type == "plants_list":
        plants = await plant_collection.find().to_list(length=None)
        items = []
        for p in plants:
            items.append({
                "id": str(p["_id"]),
                "name": p.get("name", p.get("plant_name", "Unknown")),
                "status": p.get("status", "N/A"),
                "todayKwh": p.get("todayKwh", "N/A"),
            })
        names = ", ".join(i["name"] for i in items) if items else "None"
        return {
            "action": "query",
            "data": items,
            "message": f"Found {len(items)} plant(s): {names}."
        }

    # ── plant_detail ──
    elif query_type == "plant_detail":
        hint = params.get("id", "")
        plant = None
        # Try ObjectId first
        try:
            plant = await plant_collection.find_one({"_id": ObjectId(hint)})
        except Exception:
            pass
        if not plant:
            for field in ["name", "plant_name"]:
                plant = await plant_collection.find_one({field: {"$regex": hint, "$options": "i"}})
                if plant:
                    break
        if not plant:
            return {"action": "query", "message": f"No plant found matching '{hint}'."}
        plant["_id"] = str(plant["_id"])
        return {
            "action": "query",
            "data": plant,
            "message": f"Plant '{plant.get('name', plant.get('plant_name'))}' — "
                       f"Status: {plant.get('status','N/A')}, "
                       f"Today: {plant.get('todayKwh','N/A')}, Total: {plant.get('totalKwh','N/A')}."
        }

    # ── inverters_list ──
    elif query_type == "inverters_list":
        inverters = await inverter_collection.find().to_list(length=None)
        items = []
        for inv in inverters:
            items.append({
                "id": str(inv["_id"]),
                "name": inv.get("device_name", "Unknown"),
                "status": inv.get("status", "N/A"),
                "today_generation": inv.get("today_generation", "N/A"),
            })
        names = ", ".join(i["name"] for i in items) if items else "None"
        return {
            "action": "query",
            "data": items,
            "message": f"Found {len(items)} inverter(s): {names}."
        }

    # ── inverter_detail ──
    elif query_type == "inverter_detail":
        hint = params.get("id", "")
        inv = None
        try:
            inv = await inverter_collection.find_one({"_id": ObjectId(hint)})
        except Exception:
            pass
        if not inv:
            inv = await inverter_collection.find_one({"device_name": {"$regex": hint, "$options": "i"}})
        if not inv:
            return {"action": "query", "message": f"No inverter found matching '{hint}'."}
        inv["_id"] = str(inv["_id"])
        inv["plant_id"] = str(inv.get("plant_id", ""))
        return {
            "action": "query",
            "data": inv,
            "message": f"Inverter '{inv.get('device_name')}' — "
                       f"Status: {inv.get('status','N/A')}, "
                       f"Today: {inv.get('today_generation','N/A')} kWh, "
                       f"Total: {inv.get('total_generation','N/A')} kWh."
        }

    # ── sensors_list ──
    elif query_type == "sensors_list":
        sensors = await sensor_collection.find().to_list(length=None)
        items = []
        for s in sensors:
            items.append({
                "id": str(s["_id"]),
                "name": s.get("device_name", "Unknown"),
                "type": s.get("sensor_type", "N/A"),
                "status": s.get("status", "N/A"),
            })
        names = ", ".join(i["name"] for i in items) if items else "None"
        return {
            "action": "query",
            "data": items,
            "message": f"Found {len(items)} sensor(s): {names}."
        }

    # ── sensor_detail ──
    elif query_type == "sensor_detail":
        hint = params.get("id", "")
        sensor = None
        try:
            sensor = await sensor_collection.find_one({"_id": ObjectId(hint)})
        except Exception:
            pass
        if not sensor:
            sensor = await sensor_collection.find_one({"device_name": {"$regex": hint, "$options": "i"}})
        if not sensor:
            return {"action": "query", "message": f"No sensor found matching '{hint}'."}
        sensor["_id"] = str(sensor["_id"])
        sensor["plant_id"] = str(sensor.get("plant_id", ""))
        return {
            "action": "query",
            "data": sensor,
            "message": f"Sensor '{sensor.get('device_name')}' — "
                       f"Type: {sensor.get('sensor_type','N/A')}, "
                       f"Manufacturer: {sensor.get('manufacturer','N/A')}, "
                       f"Status: {sensor.get('status','N/A')}."
        }

    # ── alerts_list ──
    elif query_type == "alerts_list":
        alerts = await alert_collection.find().to_list(length=None)
        items = []
        for a in alerts:
            items.append({
                "id": str(a["_id"]),
                "alert_name": a.get("alert_name", "N/A"),
                "severity": a.get("severity", "N/A"),
                "device_name": a.get("device_name", "N/A"),
                "status": a.get("status", "N/A"),
                "message": a.get("message", ""),
            })
        if not items:
            return {"action": "query", "message": "No alerts found."}
        summary = "; ".join(f"{a['alert_name']} ({a['severity']})" for a in items[:5])
        return {
            "action": "query",
            "data": items,
            "message": f"Found {len(items)} alert(s): {summary}{'...' if len(items) > 5 else ''}."
        }

    # ── alerts_count ──
    elif query_type == "alerts_count":
        count = await alert_collection.count_documents({})
        return {
            "action": "query",
            "data": {"count": count},
            "message": f"There are currently {count} alert(s) in the system."
        }

    # ── devices_summary ──
    elif query_type == "devices_summary":
        devices = await devices_collection.find().to_list(length=None)
        items = [{"type": d["type"], "count": d["count"]} for d in devices]
        summary = ", ".join(f"{d['type']}: {d['count']}" for d in items)
        return {
            "action": "query",
            "data": items,
            "message": f"Device summary → {summary}."
        }

    else:
        return {"action": "query", "message": f"Unknown query type: '{query_type}'."}


# ─────────────────────────────────────────────
# Navigate Handler
# ─────────────────────────────────────────────
async def handle_navigate(route: str, params: dict) -> dict:
    """
    If route contains ':id', resolve params['id'] to an actual MongoDB _id
    and return the resolved route.
    """
    if ":id" not in route:
        return {"action": "navigate", "route": route, "message": f"Navigating to {route}"}

    hint = params.get("id", "")
    resolved_id = None

    if "/inverters" in route:
        resolved_id = await resolve_entity_id(inverter_collection, hint, "device_name")
        fallback = "/inverters"
    elif "/plants" in route:
        resolved_id = await resolve_entity_id(plant_collection, hint, "plant_name")
        fallback = "/plants"
    elif "/sensors" in route:
        resolved_id = await resolve_entity_id(sensor_collection, hint, "device_name")
        fallback = "/sensors"
    else:
        fallback = "/"

    if resolved_id:
        resolved_route = route.replace(":id", resolved_id)
        return {
            "action": "navigate",
            "route": resolved_route,
            "params": {"id": resolved_id},
            "message": f"Opening detail for '{hint}'."
        }
    else:
        # Fall back to list page with a note
        return {
            "action": "navigate",
            "route": fallback,
            "message": f"Could not find '{hint}' specifically. Showing all {fallback.strip('/')}."
        }


# ─────────────────────────────────────────────
# Action Handler
# ─────────────────────────────────────────────
async def handle_action(action_type: str, params: dict) -> dict:
    if action_type == "delete_alert":
        alert_id = params.get("id", "")
        try:
            result = await alert_collection.delete_one({"_id": ObjectId(alert_id)})
            if result.deleted_count == 0:
                return {"action": "action", "message": f"Alert '{alert_id}' not found."}
            return {"action": "action", "message": f"Alert deleted successfully."}
        except Exception as e:
            return {"action": "action", "message": f"Failed to delete alert: {e}"}

    elif action_type == "create_export":
        from datetime import datetime
        export_doc = {
            "created_at": datetime.now().isoformat(),
            "status": "pending",
            **params
        }
        await alert_collection.insert_one(export_doc)  # Would be export_collection in full impl
        return {"action": "action", "message": "Export record created successfully."}

    else:
        return {"action": "action", "message": f"Action type '{action_type}' is not yet supported."}


# ─────────────────────────────────────────────
# Main Entry Point
# ─────────────────────────────────────────────
async def process_agent_command(text: str) -> dict:
    """
    Main agent handler. Sends user text to Gemini for intent classification,
    then dispatches to the appropriate handler.
    """
    try:
        prompt = build_prompt(text)
        intent = generate_content(prompt)

        if not isinstance(intent, dict):
            raise ValueError("Gemini response is not a dict")

    except Exception as e:
        return {
            "action": "unknown",
            "message": f"I couldn't understand that command. Please try again. (Error: {e})"
        }

    action = intent.get("action", "unknown")
    params = intent.get("params", {})

    if action == "navigate":
        route = intent.get("route", "/")
        return await handle_navigate(route, params)

    elif action == "query":
        query_type = intent.get("query_type", "")
        return await handle_query(query_type, params)

    elif action == "action":
        action_type = intent.get("action_type", "")
        return await handle_action(action_type, params)

    else:
        return {
            "action": "unknown",
            "message": intent.get("message", "I didn't understand that command.")
        }
