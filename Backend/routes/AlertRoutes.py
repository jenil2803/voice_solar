from fastapi import APIRouter
from controllers.AlertController import getAllAlerts, addAlert, deleteAlert, getAlertById
from models.AlertModel import Alert

router = APIRouter()

@router.get("/alerts/")
async def get_alerts():
    return await getAllAlerts()

@router.post("/alert/")
async def post_alert(alert: Alert):
    return await addAlert(alert)

@router.delete("/alert/{alert_id}")
async def delete_alert(alert_id: str):
    return await deleteAlert(alert_id)

@router.get("/alert/{alert_id}")
async def get_alert_by_id(alert_id: str):
    return await getAlertById(alert_id)