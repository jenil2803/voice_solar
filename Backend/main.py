from fastapi import FastAPI

# Import Routers
from routes.UserRoutes import router as user_router
from routes.PlantRoutes import router as plant_router
from routes.InverterRoutes import router as inverter_router
from routes.SensorRoutes import router as sensor_router
from routes.SLMSRoutes import router as slms_router
from routes.AlertRoutes import router as alert_router
from routes.ExportRoutes import router as export_router
from routes.DashboardRoutes import router as dashboard_router
from routes.AgentRoutes import router as agent_router


# Import CORS middleware
from fastapi.middleware.cors import CORSMiddleware


# Create FastAPI App
app = FastAPI(
    title="Solar Monitoring API",
    description="Backend API for Solar Plant Monitoring System",
    version="1.0.0"
)


# Enable CORS (required for Flutter frontend)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
    expose_headers=["*"]
)


# Include Routers
app.include_router(user_router)
app.include_router(plant_router)
app.include_router(inverter_router)
app.include_router(sensor_router)
app.include_router(slms_router)
app.include_router(alert_router)
app.include_router(export_router)
app.include_router(dashboard_router)
app.include_router(agent_router)


# Root API
@app.get("/")
async def root():
    return {"message": "Solar Monitoring API Running"}