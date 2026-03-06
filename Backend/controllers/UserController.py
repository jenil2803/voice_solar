from models.UserModel import User, UserOut, UserLogin
from bson import ObjectId
from config.database import user_collection
from fastapi import HTTPException
from fastapi.responses import JSONResponse
import bcrypt


async def addUser(user: User):

    new_user = user.dict()

    await user_collection.insert_one(new_user)

    return JSONResponse(
        status_code=201,
        content={"message": "User created successfully"}
    )


async def getAllUsers():

    users = await user_collection.find().to_list(length=None)

    for user in users:
        user["_id"] = str(user["_id"])

    return [UserOut(**user) for user in users]


async def loginUser(request: UserLogin):

    foundUser = await user_collection.find_one({"email": request.email})

    if not foundUser:
        raise HTTPException(status_code=404, detail="User not found")

    if bcrypt.checkpw(request.password.encode(), foundUser["password"]):

        foundUser["_id"] = str(foundUser["_id"])

        return {
            "message": "Login successful",
            "user": UserOut(**foundUser)
        }

    else:
        raise HTTPException(status_code=401, detail="Invalid password")