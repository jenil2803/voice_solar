from config.database import inverter_collection, plant_collection
from models.InverterModel import Inverter, InverterOut
from bson import ObjectId
from fastapi import HTTPException


async def getAllInverters():
    inverters = await inverter_collection.find().to_list(length=None)

    for inv in inverters:
        inv["_id"] = str(inv["_id"])
        inv["plant_id"] = str(inv["plant_id"])

        plant = await plant_collection.find_one({"_id": ObjectId(inv["plant_id"])})

        if plant:
            plant["_id"] = str(plant["_id"])
            inv["plant"] = plant

    return [InverterOut(**inv) for inv in inverters]


async def addInverter(inverter: Inverter):
    inverter.plant_id = ObjectId(inverter.plant_id)
    await inverter_collection.insert_one(inverter.dict())

    return {"message": "Inverter Created Successfully"}


async def deleteInverter(inverter_id: str):
    await inverter_collection.delete_one({"_id": ObjectId(inverter_id)})
    return {"message": "Inverter Deleted Successfully"}


async def getInverterById(inverter_id: str):

    inverter = await inverter_collection.find_one({"_id": ObjectId(inverter_id)})

    if not inverter:
        raise HTTPException(status_code=404, detail="Inverter not found")

    inverter["_id"] = str(inverter["_id"])
    inverter["plant_id"] = str(inverter["plant_id"])

    return InverterOut(**inverter)