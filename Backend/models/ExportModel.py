from pydantic import BaseModel, Field, validator
from bson import ObjectId
from datetime import datetime


class Export(BaseModel):

    plant_id: str
    data_source: str
    duration_type: str
    start_date: datetime
    end_date: datetime
    file_url: str


class ExportOut(Export):

    id: str = Field(alias="_id")

    @validator("id", pre=True, always=True)
    def convert_objectId(cls, v):
        if isinstance(v, ObjectId):
            return str(v)
        return v