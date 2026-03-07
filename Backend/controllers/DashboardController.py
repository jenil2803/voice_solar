from datetime import datetime
from config.database import (
    user_collection, plant_collection, overview_collection, 
    chart_data_collection, devices_collection, energy_logs_collection
)

async def getDashboardData(period: str = "monthly"):
    # 1. Fetch User
    user = await user_collection.find_one({})
    user_name = user.get("userName", "Guest") if user else "Guest"
    
    # 2. Fetch Overview & Net Zero stats
    overview = await overview_collection.find_one({"type": "dashboard_stats"})
    if not overview:
        # Fallback if not seeded
        energyProduction = {
            "todayKwh": "0 kWh",
            "percentage": 0.0,
            "totalProduction": "0 kWh",
            "totalCapacity": "0 kWh"
        }
        netZero = {
            "co2Reduced": "0",
            "coalSaved": "0",
            "treesPlanted": "0"
        }
        plantsStatus = {
            "totalPlants": 0,
            "active": 0,
            "alert": 0,
            "partiallyActive": 0,
            "expired": 0
        }
    else:
        import random
        energyProduction = overview.get("energyProduction")
        netZero = overview.get("netZero")
        plantsStatus = overview.get("plantsStatus")

        # Simulate dynamic live data for the dashboard Pie Chart & Net Zero
        try:
            base_pct = float(energyProduction.get("percentage", 50.75))
            energyProduction["percentage"] = round(base_pct + random.uniform(-1.5, 3.5), 2)
            
            base_today = float(str(energyProduction.get("todayKwh", "42.8 kWh")).replace(" kWh", ""))
            energyProduction["todayKwh"] = f"{round(base_today + random.uniform(0.1, 1.2), 1)} kWh"
            
            base_co2 = float(str(netZero.get("co2Reduced", "1.03k")).replace("k", ""))
            netZero["co2Reduced"] = f"{round(base_co2 + random.uniform(0.01, 0.05), 2)}k"
            
            base_coal = float(str(netZero.get("coalSaved", "1.4 T")).replace(" T", ""))
            netZero["coalSaved"] = f"{round(base_coal + random.uniform(0.01, 0.08), 2)} T"
        except Exception:
            pass # fallback to original static data if parsing fails
        
    # 3. Fetch Devices
    devices_cursor = devices_collection.find({})
    devices = []
    async for device in devices_cursor:
        devices.append({
            "type": device["type"],
            "count": device["count"],
            "flex": device["flex"]
        })
        
    # 4. Dynamic Chart Data Aggregation
    now = datetime.now()
    bars = []
    period_label = ""
    max_y = 40.0
    
    if period == "monthly":
        period_label = now.strftime("%B %Y")
        cursor = energy_logs_collection.find({
            "year": now.year,
            "month": now.month
        }).sort("day", 1)
        async for log in cursor:
            bars.append({"x": log["day"], "y": log["kwh"]})
        if bars:
            max_y = max([b["y"] for b in bars]) * 1.2
            
    elif period == "yearly":
        period_label = str(now.year)
        pipeline = [
            {"$match": {"year": now.year}},
            {"$group": {
                "_id": "$month",
                "total_kwh": {"$sum": "$kwh"}
            }},
            {"$sort": {"_id": 1}}
        ]
        cursor = energy_logs_collection.aggregate(pipeline)
        async for res in cursor:
            bars.append({"x": res["_id"], "y": round(res["total_kwh"], 2)})
        if bars:
            max_y = max([b["y"] for b in bars]) * 1.2
            
    elif period == "lifetime":
        period_label = "Lifetime"
        pipeline = [
            {"$group": {
                "_id": "$year",
                "total_kwh": {"$sum": "$kwh"}
            }},
            {"$sort": {"_id": 1}}
        ]
        cursor = energy_logs_collection.aggregate(pipeline)
        async for res in cursor:
            bars.append({"x": res["_id"], "y": round(res["total_kwh"], 2)})
        if bars:
            max_y = max([b["y"] for b in bars]) * 1.2
            
    chartData = {
        "periodLabel": period_label,
        "periodType": period,
        "bars": bars,
        "maxY": float(max_y if max_y > 0 else 40.0)
    }
        
    # 5. Fetch Plants Details
    plants_cursor = plant_collection.find({})
    plants = []
    async for plant in plants_cursor:
        plants.append({
                        "name": str(plant.get("plant_name", plant.get("name", "Unknown"))),
            "status": str(plant.get("status", "Unknown")),
            "todayKwh": str(plant.get("todayKwh", "0")),
            "totalKwh": str(plant.get("totalKwh", "0")),
            "capacityKwh": str(plant.get("capacityKwh", "0")),
            "lastUpdated": str(plant.get("lastUpdated", "Unknown")),
            "city": str(plant.get("city", "N/A")),
            "state": str(plant.get("state", "N/A")),
        })
        
    dashboard_data = {
        "userName": user_name,
        "energyProduction": energyProduction,
        "devices": devices,
        "plantsStatus": plantsStatus,
        "netZero": netZero,
        "chartData": chartData,
        "plants": plants
    }
    
    return dashboard_data

