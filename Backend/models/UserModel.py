from pydantic import BaseModel, Field, validator
from bson import ObjectId
import bcrypt


class User(BaseModel):

    name: str
    email: str
    password: str
    role: str
    status: bool

    @validator("password", pre=True, always=True)
    def encrypt_password(cls, v):
        return bcrypt.hashpw(v.encode("utf-8"), bcrypt.gensalt())


class UserOut(User):

    id: str = Field(alias="_id")

    @validator("id", pre=True, always=True)
    def convert_objectId(cls, v):
        if isinstance(v, ObjectId):
            return str(v)
        return v


class UserLogin(BaseModel):
    email: str
    password: str