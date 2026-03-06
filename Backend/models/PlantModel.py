from pydantic import BaseModel, Field, validator
from bson import ObjectId


class Plant(BaseModel):

    plant_name: str
    plant_type: str
    installation_date: str
    address: str
    country: str
    state: str
    city: str
    latitude: float
    longitude: float
    status: str


class PlantOut(Plant):

    id: str = Field(alias="_id")

    @validator("id", pre=True, always=True)
    def convert_objectId(cls, v):
        if isinstance(v, ObjectId):
            return str(v)
        return v