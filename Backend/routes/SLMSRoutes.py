from fastapi import APIRouter
from controllers.SLMSController import getAllSLMSDevices, addSLMSDevice, deleteSLMSDevice, getSLMSDeviceById
from models.SLMSModel import SLMSDevice

router = APIRouter()

@router.get("/slms/")
async def get_slms_devices():
    return await getAllSLMSDevices()

@router.post("/slms/")
async def post_slms_device(device: SLMSDevice):
    return await addSLMSDevice(device)

@router.delete("/slms/{device_id}")
async def delete_slms_device(device_id: str):
    return await deleteSLMSDevice(device_id)

@router.get("/slms/{device_id}")
async def get_slms_device_by_id(device_id: str):
    return await getSLMSDeviceById(device_id)