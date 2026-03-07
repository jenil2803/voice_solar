from pydantic import BaseModel, Field, validator
from bson import ObjectId


class Inverter(BaseModel):

    plant_id: str
    device_name: str
    manufacturer: str
    today_generation: float
    total_generation: float
    status: str
    category: str
    lastUpdated: str


class InverterOut(Inverter):

    id: str = Field(alias="_id")

    @validator("id", pre=True, always=True)
    def convert_objectId(cls, v):
        if isinstance(v, ObjectId):
            return str(v)
        return v