import asyncio
from motor.motor_asyncio import AsyncIOMotorClient
import bcrypt

# MongoDB Connection URL
MONGO_URL = "mongodb+srv://solaradmin:strongpassword123@solar-monitoring-cluste.9drs1o7.mongodb.net/solar_monitoring_system?retryWrites=true&w=majority"
DATABASE_NAME = "solar_monitoring_system"

async def create_users():
    client = AsyncIOMotorClient(MONGO_URL)
    db = client[DATABASE_NAME]

    def encrypt_password(password):
        hashed = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt())
        return hashed.decode("utf-8")

    test_users = [
        {
            "name": "Mayank",
            "email": "mayank",
            "password": encrypt_password("mayank@123"),
            "role": "admin",
            "status": True
        },
        {
            "name": "Test User 1",
            "email": "test1@helionav.com",
            "password": encrypt_password("password123"),
            "role": "viewer",
            "status": True
        },
        {
            "name": "Test User 2",
            "email": "test2@helionav.com",
            "password": encrypt_password("password123"),
            "role": "viewer",
            "status": True
        },
        {
            "name": "Test User 3",
            "email": "test3@helionav.com",
            "password": encrypt_password("password123"),
            "role": "viewer",
            "status": True
        }
    ]

    print("Creating HelioNav test users...")
    
    # We will just insert them. If "email" was meant to be truly unique, 
    # we would check or use update_one with upsert, but insert_many is fine for testing.
    result = await db["users"].insert_many(test_users)
    print(f"Created {len(result.inserted_ids)} users successfully")
    
    client.close()

if __name__ == "__main__":
    asyncio.run(create_users())
