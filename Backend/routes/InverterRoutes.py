from fastapi import APIRouter
from controllers.InverterController import getAllInverters, addInverter, deleteInverter, getInverterById
from models.InverterModel import Inverter

router = APIRouter()

@router.get("/inverters/")
async def get_inverters():
    return await getAllInverters()

@router.post("/inverter/")
async def post_inverter(inverter: Inverter):
    return await addInverter(inverter)

@router.delete("/inverter/{inverter_id}")
async def delete_inverter(inverter_id: str):
    return await deleteInverter(inverter_id)

@router.get("/inverter/{inverter_id}")
async def get_inverter_by_id(inverter_id: str):
    return await getInverterById(inverter_id)