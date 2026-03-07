from config.database import slms_device_collection
from models.SLMSModel import SLMSDevice, SLMSDeviceOut
from bson import ObjectId
from fastapi import HTTPException


async def getAllSLMSDevices():

    devices = await slms_device_collection.find().to_list(length=None)

    for device in devices:
        device["_id"] = str(device["_id"])
        device["plant_id"] = str(device["plant_id"])

    return [SLMSDeviceOut(**device) for device in devices]


async def addSLMSDevice(device: SLMSDevice):

    device.plant_id = ObjectId(device.plant_id)

    await slms_device_collection.insert_one(device.dict())

    return {"message": "SLMS Device Created Successfully"}


async def deleteSLMSDevice(device_id: str):

    await slms_device_collection.delete_one({"_id": ObjectId(device_id)})

    return {"message": "SLMS Device Deleted Successfully"}


async def getSLMSDeviceById(device_id: str):

    device = await slms_device_collection.find_one({"_id": ObjectId(device_id)})

    if not device:
        raise HTTPException(status_code=404, detail="Device not found")

    device["_id"] = str(device["_id"])
    device["plant_id"] = str(device["plant_id"])

    return SLMSDeviceOut(**device)