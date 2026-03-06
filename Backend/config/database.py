from motor.motor_asyncio import AsyncIOMotorClient
import mongomock

# MongoDB Connection URL
MONGO_URL = "mongodb+srv://solaradmin:strongpassword123@solar-monitoring-cluste.9drs1o7.mongodb.net/?appName=solar-monitoring-cluster"

# Database Name
DATABASE_NAME = "solar_monitoring_system"

# Create MongoDB Client
# client = AsyncIOMotorClient(MONGO_URL)
client = mongomock.MongoClient()

# Select Database
db = client[DATABASE_NAME]


# ==============================
# Collections
# ==============================

user_collection = db["users"]

plant_collection = db["plants"]

inverter_collection = db["inverters"]

sensor_collection = db["sensors"]

sensor_data_collection = db["sensor_data"]

slms_device_collection = db["slms_devices"]

slms_data_collection = db["slms_data"]

alert_collection = db["alerts"]

export_collection = db["exports"]