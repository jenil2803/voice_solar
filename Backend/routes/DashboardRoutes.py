from fastapi import APIRouter
from controllers.DashboardController import getDashboardData

router = APIRouter()

@router.get("/dashboard")
async def get_dashboard(period: str = "monthly"):
    return await getDashboardData(period)
