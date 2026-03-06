from config.database import plant_collection
from models.PlantModel import Plant, PlantOut
from bson import ObjectId
from fastapi import HTTPException


async def getAllPlants():
    plants = await plant_collection.find().to_list(length=None)

    for plant in plants:
        plant["_id"] = str(plant["_id"])

    return [PlantOut(**plant) for plant in plants]


async def addPlant(plant: Plant):
    result = await plant_collection.insert_one(plant.dict())
    return {"message": "Plant Created Successfully"}


async def deletePlant(plant_id: str):
    await plant_collection.delete_one({"_id": ObjectId(plant_id)})
    return {"message": "Plant Deleted Successfully"}


async def getPlantById(plant_id: str):
    plant = await plant_collection.find_one({"_id": ObjectId(plant_id)})

    if not plant:
        raise HTTPException(status_code=404, detail="Plant not found")

    plant["_id"] = str(plant["_id"])

    return PlantOut(**plant)