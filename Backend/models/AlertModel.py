from pydantic import BaseModel, Field, validator
from bson import ObjectId
from datetime import datetime


class Alert(BaseModel):

    plant_id: str
    device_id: str
    device_name: str
    alert_name: str
    severity: str
    message: str
    occurrence_time: datetime
    status: str


class AlertOut(Alert):

    id: str = Field(alias="_id")

    @validator("id", pre=True, always=True)
    def convert_objectId(cls, v):
        if isinstance(v, ObjectId):
            return str(v)
        return v