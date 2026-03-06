from fastapi import APIRouter
from pydantic import BaseModel
import re

router = APIRouter(tags=["AI Agent"])

class CommandRequest(BaseModel):
    text: str

@router.post("/agent/command/")
async def process_command(request: CommandRequest):
    text = request.text.lower()
    
    # Simple rule-based logic to extract intent
    if re.search(r'\b(plant|plants)\b', text):
        return {"action": "navigate", "route": "/plants", "message": "Navigating to Plants"}
    elif re.search(r'\b(report|reports|export)\b', text):
        return {"action": "navigate", "route": "/reports", "message": "Navigating to Reports"}
    elif re.search(r'\b(dash|dashboard|home|main)\b', text):
        return {"action": "navigate", "route": "/", "message": "Navigating to Dashboard"}
    
    # Generic generic/help responses
    return {"action": "unknown", "message": "I didn't quite catch that. Try saying 'Take me to plants' or 'Show reports'."}
