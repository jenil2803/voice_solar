from fastapi import APIRouter
from config.database import plant_collection, inverter_collection, sensor_collection

async def getDashboardData():
    # In a real production scenario, this function would run MongoDB aggregations
    # across collection to return 'DashboardData'.
    # For now, we will return a static dictionary matching the schema expected 
    # by the `DashboardData` model in `cook/lib/models/dashboard_models.dart`.
    
    # 1. Energy Production
    energyProduction = {
        "todayKwh": "20 kWh",
        "percentage": 50.75,
        "totalProduction": "42.8 kWh",
        "totalCapacity": "42.8 kWh"
    }
    
    # 2. Devices count
    devices = [
        {"type": "MFM", "count": 5, "flex": 5},
        {"type": "WFM", "count": 1, "flex": 1},
        {"type": "SLMS", "count": 2, "flex": 2},
        {"type": "Inverters", "count": 4, "flex": 4}
    ]
    
    # 3. Plants Status Data
    plantsStatus = {
        "totalPlants": 45,
        "active": 30,
        "alert": 10,
        "partiallyActive": 10,
        "expired": 10
    }
    
    # 4. Net Zero
    netZero = {
        "co2Reduced": "1.03k",
        "coalSaved": "1.4 T",
        "treesPlanted": "155K"
    }
    
    # 5. Chart Data
    # Generate 22 points
    bars = []
    for i in range(22):
        y = 38 if i == 19 else 20 + (i % 5) * 4
        bars.append({"x": i + 1, "y": float(y)})
        
    chartData = {
        "periodLabel": "September 2026",
        "periodType": "yearly",
        "bars": bars,
        "maxY": 40.0
    }
    
    # 6. Plants Details
    plants = [
        {
            "name": "Kutch Plant",
            "status": "partiallyActive",
            "todayKwh": "36489 Kwh",
            "totalKwh": "36489 Kwh",
            "capacityKwh": "36489 Kwh",
            "lastUpdated": "Jan 10, 8:00 AM"
        }
    ]
    # Add 5 more plants exactly as they are in dart code
    for i in range(5):
        plants.append({
            "name": f"Plant {i + 2}",
            "status": "expired" if i >= 4 else "active",
            "todayKwh": "36489 Kwh",
            "totalKwh": "36489 Kwh",
            "capacityKwh": "36489 Kwh",
            "lastUpdated": "Jan 10, 8:00 AM"
        })
        
    dashboard_data = {
        "userName": "Dhruti",
        "energyProduction": energyProduction,
        "devices": devices,
        "plantsStatus": plantsStatus,
        "netZero": netZero,
        "chartData": chartData,
        "plants": plants
    }
    
    return dashboard_data
