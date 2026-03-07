from config.database import export_collection
from models.ExportModel import Export, ExportOut
from bson import ObjectId


async def getAllExports():

    exports = await export_collection.find().to_list(length=None)

    for export in exports:
        export["_id"] = str(export["_id"])

    return [ExportOut(**export) for export in exports]


async def createExport(export: Export):

    await export_collection.insert_one(export.dict())

    return {"message": "Export Created Successfully"}


async def deleteExport(export_id: str):

    await export_collection.delete_one({"_id": ObjectId(export_id)})

    return {"message": "Export Deleted Successfully"}