from fastapi import APIRouter
from controllers.ExportController import getAllExports, createExport, deleteExport
from models.ExportModel import Export

router = APIRouter()

@router.get("/exports/")
async def get_exports():
    return await getAllExports()

@router.post("/export/")
async def post_export(export: Export):
    return await createExport(export)

@router.delete("/export/{export_id}")
async def delete_export(export_id: str):
    return await deleteExport(export_id)