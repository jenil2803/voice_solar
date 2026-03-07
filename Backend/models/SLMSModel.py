from pydantic import BaseModel, Field, validator
from bson import ObjectId


class SLMSDevice(BaseModel):

    plant_id: str
    device_name: str
    number_of_ct: int
    total_current: float
    status: str


class SLMSDeviceOut(SLMSDevice):

    id: str = Field(alias="_id")

    @validator("id", pre=True, always=True)
    def convert_objectId(cls, v):
        if isinstance(v, ObjectId):
            return str(v)
        return v