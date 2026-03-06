from pydantic import BaseModel, Field, validator
from bson import ObjectId


class Sensor(BaseModel):

    plant_id: str
    device_name: str
    sensor_type: str
    manufacturer: str
    status: str


class SensorOut(Sensor):

    id: str = Field(alias="_id")

    @validator("id", pre=True, always=True)
    def convert_objectId(cls, v):
        if isinstance(v, ObjectId):
            return str(v)
        return v