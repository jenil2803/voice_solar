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
            "plant_name": "Kutch Plant",
            "plant_type": "Ground Mount",
            "installation_date": "2020-05-12",
            "address": "Solar Park, Bhadla",
            "country": "India",
            "state": "Gujarat",
            "city": "Bhuj",
            "latitude": 23.25,
            "longitude": 69.66,
            "status": "partiallyActive",
            "todayKwh": "36489 Kwh",
            "totalKwh": "36489 Kwh",
            "capacityKwh": "36489 Kwh",
            "lastUpdated": "Jan 10, 8:00 AM",
        },
        {
            "plant_name": "Ahmedabad Solar",
            "plant_type": "Rooftop Integration",
            "installation_date": "2022-11-01",
            "address": "SG Highway Tech Park",
            "country": "India",
            "state": "Gujarat",
            "city": "Ahmedabad",
            "latitude": 23.02,
            "longitude": 72.57,
            "status": "active",
            "todayKwh": "42000 Kwh",
            "totalKwh": "1.2M Kwh",
            "capacityKwh": "50000 Kwh",
            "lastUpdated": "Jan 10, 9:30 AM",
        },
        {
            "plant_name": "Surat Roof",
            "plant_type": "Commercial Rooftop",
            "installation_date": "2021-08-15",
            "address": "Textile Hub Center",
            "country": "India",
            "state": "Gujarat",
            "city": "Surat",
            "latitude": 21.17,
            "longitude": 72.83,
            "status": "alert",
            "todayKwh": "12000 Kwh",
            "totalKwh": "500K Kwh",
            "capacityKwh": "25000 Kwh",
            "lastUpdated": "Jan 10, 10:15 AM",
        },
        {
            "plant_name": "Jodhpur Station",
            "plant_type": "Utility Scale",
            "installation_date": "2019-02-20",
            "address": "Desert Tech Center",
            "country": "India",
            "state": "Rajasthan",
            "city": "Jodhpur",
            "latitude": 26.23,
            "longitude": 73.02,
            "status": "active",
            "todayKwh": "89000 Kwh",
            "totalKwh": "4.5M Kwh",
            "capacityKwh": "100000 Kwh",
            "lastUpdated": "Jan 10, 11:45 AM",
        },
        {
            "plant_name": "Bhadla Solar Park",
            "plant_type": "Solar Farm",
            "installation_date": "2018-09-10",
            "address": "Bhadla Phase 1",
            "country": "India",
            "state": "Rajasthan",
            "city": "Phalodi",
            "latitude": 27.53,
            "longitude": 71.91,
            "status": "active",
            "todayKwh": "250489 Kwh",
            "totalKwh": "12.3M Kwh",
            "capacityKwh": "500000 Kwh",
            "lastUpdated": "Jan 10, 12:00 PM",
        },
        {
            "plant_name": "Pune Industrial",
            "plant_type": "Commercial Microgrid",
            "installation_date": "2023-01-05",
            "address": "MIDC Area",
            "country": "India",
            "state": "Maharashtra",
            "city": "Pune",
            "latitude": 18.52,
            "longitude": 73.85,
            "status": "expired",
            "todayKwh": "0 Kwh",
            "totalKwh": "230K Kwh",
            "capacityKwh": "15000 Kwh",
            "lastUpdated": "Jan 08, 4:00 PM",
        },
        {
            "plant_name": "Bengaluru IT Park",
            "plant_type": "Rooftop Array",
            "installation_date": "2021-04-20",
            "address": "Whitefield Phase 2",
            "country": "India",
            "state": "Karnataka",
            "city": "Bengaluru",
            "latitude": 12.97,
            "longitude": 77.59,
            "status": "partiallyActive",
            "todayKwh": "18500 Kwh",
            "totalKwh": "800K Kwh",
            "capacityKwh": "30000 Kwh",
            "lastUpdated": "Jan 10, 8:45 AM",
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

    from datetime import datetime, timedelta
    import random

    # Add Inverters
    print("Seeding inverters...")
    await db["inverters"].delete_many({})
    
    plants_cursor = db["plants"].find({})
    all_plants = await plants_cursor.to_list(length=None)
    
    if all_plants:
        inverters_data = []
        manufacturers = ["Mindra", "Growatt", "SMA", "Huawei", "Sungrow"]
        categories = ["inverter", "string inverter", "central inverter"]
        statuses = ["active", "active", "active", "active", "alert", "partiallyActive", "expired"]
        
        for i in range(25):
            plant = random.choice(all_plants)
            today_gen = round(random.uniform(50, 500), 2)
            total_gen = round(today_gen * random.uniform(100, 500), 2)
            
            inverters_data.append({
                "plant_id": plant["_id"],
                "device_name": f"{plant.get('plant_name', 'Plant')} Inv {i+1}",
                "manufacturer": random.choice(manufacturers),
                "today_generation": today_gen,
                "total_generation": total_gen,
                "status": random.choice(statuses),
                "category": random.choice(categories),
                "lastUpdated": datetime.now().strftime("%b %d, %I:%M %p")
            })
            
        await db["inverters"].insert_many(inverters_data)

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
