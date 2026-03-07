import certifi
from motor.motor_asyncio import AsyncIOMotorClient

# MongoDB Connection URL
MONGO_URL = "mongodb+srv://solaradmin:strongpassword123@solar-monitoring-cluste.9drs1o7.mongodb.net/solar_monitoring_system?retryWrites=true&w=majority"

# Database Name
DATABASE_NAME = "solar_monitoring_system"

# Create MongoDB Client with certifi CA bundle to fix SSL handshake errors
client = AsyncIOMotorClient(MONGO_URL, tlsCAFile=certifi.where())

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

# New Dashboard Collections
overview_collection = db["overview"]
chart_data_collection = db["chart_data"]
devices_collection = db["devices"]
energy_logs_collection = db["energy_logs"]
