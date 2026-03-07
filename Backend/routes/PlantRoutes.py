from fastapi import APIRouter
from controllers.PlantController import getAllPlants, addPlant, deletePlant, getPlantById
from models.PlantModel import Plant

router = APIRouter()

@router.get("/plants/")
async def get_plants():
    return await getAllPlants()

@router.post("/plant/")
async def post_plant(plant: Plant):
    return await addPlant(plant)

@router.delete("/plant/{plant_id}")
async def delete_plant(plant_id: str):
    return await deletePlant(plant_id)

@router.get("/plant/{plant_id}")
async def get_plant_by_id(plant_id: str):
    return await getPlantById(plant_id)