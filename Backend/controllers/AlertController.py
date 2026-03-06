from config.database import alert_collection
from models.AlertModel import Alert, AlertOut
from bson import ObjectId
from fastapi import HTTPException


async def getAllAlerts():

    alerts = await alert_collection.find().to_list(length=None)

    for alert in alerts:
        alert["_id"] = str(alert["_id"])

    return [AlertOut(**alert) for alert in alerts]


async def addAlert(alert: Alert):

    await alert_collection.insert_one(alert.dict())

    return {"message": "Alert Created Successfully"}


async def deleteAlert(alert_id: str):

    await alert_collection.delete_one({"_id": ObjectId(alert_id)})

    return {"message": "Alert Deleted Successfully"}


async def getAlertById(alert_id: str):

    alert = await alert_collection.find_one({"_id": ObjectId(alert_id)})

    if not alert:
        raise HTTPException(status_code=404, detail="Alert not found")

    alert["_id"] = str(alert["_id"])

    return AlertOut(**alert)