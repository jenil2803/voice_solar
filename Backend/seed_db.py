import asyncio
from motor.motor_asyncio import AsyncIOMotorClient

# MongoDB Connection URL
MONGO_URL = "mongodb+srv://solaradmin:strongpassword123@solar-monitoring-cluste.9drs1o7.mongodb.net/solar_monitoring_system?retryWrites=true&w=majority"
DATABASE_NAME = "solar_monitoring_system"

async def seed():
    client = AsyncIOMotorClient(MONGO_URL)
    db = client[DATABASE_NAME]

    # 1. Seed Users
    print("Seeding users...")
    await db["users"].delete_many({})
    await db["users"].insert_one({"userName": "Mayank"})

    # 2. Seed Plants
    print("Seeding plants...")
    await db["plants"].delete_many({})
    await db["plants"].insert_many([
        {
            "name": "Kutch Plant",
            "status": "partiallyActive",
            "todayKwh": "36489 Kwh",
            "totalKwh": "36489 Kwh",
            "capacityKwh": "36489 Kwh",
            "lastUpdated": "Jan 10, 8:00 AM",
        },
        {
            "name": "Ahmedabad Solar",
            "status": "active",
            "todayKwh": "42000 Kwh",
            "totalKwh": "1.2M Kwh",
            "capacityKwh": "50000 Kwh",
            "lastUpdated": "Jan 10, 9:30 AM",
        },
        {
            "name": "Surat Roof",
            "status": "alert",
            "todayKwh": "12000 Kwh",
            "totalKwh": "500K Kwh",
            "capacityKwh": "25000 Kwh",
            "lastUpdated": "Jan 10, 10:15 AM",
        }
    ])

    # 3. Seed Devices
    print("Seeding devices...")
    await db["devices"].delete_many({})
    await db["devices"].insert_many([
        {"type": "MFM", "count": 12, "flex": 5},
        {"type": "WFM", "count": 2, "flex": 1},
        {"type": "SLMS", "count": 4, "flex": 2},
        {"type": "Inverters", "count": 8, "flex": 4},
    ])

    # 4. Seed Overview/Sustability Stats
    print("Seeding overview data...")
    await db["overview"].delete_many({})
    await db["overview"].insert_one({
        "type": "dashboard_stats",
        "energyProduction": {
            "todayKwh": "42.8 kWh",
            "percentage": 50.75,
            "totalProduction": "42.8 kWh",
            "totalCapacity": "42.8 kWh",
        },
        "netZero": {
            "co2Reduced": "1.03k",
            "coalSaved": "1.4 T",
            "treesPlanted": "155K",
        },
        "plantsStatus": {
            "totalPlants": 45,
            "active": 30,
            "alert": 5,
            "partiallyActive": 7,
            "expired": 3,
        }
    })

    # 5. Seed Historical Energy Logs (4 years)
    print("Seeding 4 years of energy logs...")
    await db["energy_logs"].delete_many({})
    
    from datetime import datetime, timedelta
    import random
    
    end_date = datetime.now()
    start_date = end_date - timedelta(days=365 * 4) # 4 years ago
    
    logs = []
    current_date = start_date
    while current_date <= end_date:
        # Generate some random solar-like data (bell curve over day, but here we store daily totals)
        # Low in winter, high in summer
        month = current_date.month
        base_power = 20 + (5 * (6 - abs(6 - month))) # Seasonal variation
        daily_kwh = base_power + random.uniform(-5, 10)
        
        logs.append({
            "date": current_date.strftime("%Y-%m-%d"),
            "year": current_date.year,
            "month": current_date.month,
            "day": current_date.day,
            "kwh": round(daily_kwh, 2),
            "revenue": round(daily_kwh * 7.5, 2) # Assume 7.5 Rs per unit
        })
        current_date += timedelta(days=1)
        
        # Insert in batches to avoid memory/timeout issues
        if len(logs) >= 500:
            await db["energy_logs"].insert_many(logs)
            logs = []
            
    if logs:
        await db["energy_logs"].insert_many(logs)

    print("Database seeding completed!")
    client.close()

if __name__ == "__main__":
    asyncio.run(seed())
