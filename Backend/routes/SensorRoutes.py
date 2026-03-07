from fastapi import APIRouter
from controllers.SensorController import getAllSensors, addSensor, deleteSensor, getSensorById
from models.SensorModel import Sensor

router = APIRouter()

@router.get("/sensors/")
async def get_sensors():
    return await getAllSensors()

@router.post("/sensor/")
async def post_sensor(sensor: Sensor):
    return await addSensor(sensor)

@router.delete("/sensor/{sensor_id}")
async def delete_sensor(sensor_id: str):
    return await deleteSensor(sensor_id)

@router.get("/sensor/{sensor_id}")
async def get_sensor_by_id(sensor_id: str):
    return await getSensorById(sensor_id)