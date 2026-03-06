from config.database import sensor_collection
from models.SensorModel import Sensor, SensorOut
from bson import ObjectId
from fastapi import HTTPException


async def getAllSensors():

    sensors = await sensor_collection.find().to_list(length=None)

    for sensor in sensors:
        sensor["_id"] = str(sensor["_id"])
        sensor["plant_id"] = str(sensor["plant_id"])

    return [SensorOut(**sensor) for sensor in sensors]


async def addSensor(sensor: Sensor):

    sensor.plant_id = ObjectId(sensor.plant_id)

    await sensor_collection.insert_one(sensor.dict())

    return {"message": "Sensor Created Successfully"}


async def deleteSensor(sensor_id: str):

    await sensor_collection.delete_one({"_id": ObjectId(sensor_id)})

    return {"message": "Sensor Deleted Successfully"}


async def getSensorById(sensor_id: str):

    sensor = await sensor_collection.find_one({"_id": ObjectId(sensor_id)})

    if not sensor:
        raise HTTPException(status_code=404, detail="Sensor not found")

    sensor["_id"] = str(sensor["_id"])
    sensor["plant_id"] = str(sensor["plant_id"])

    return SensorOut(**sensor)