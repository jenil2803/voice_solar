from fastapi import APIRouter
from pydantic import BaseModel
from controllers.AgentController import process_agent_command

router = APIRouter(tags=["AI Agent"])

class CommandRequest(BaseModel):
    text: str

@router.post("/agent/command/")
async def agent_command(request: CommandRequest):
    """
    Process a natural-language or voice command via the AI agent.
    Returns one of:
      - { action: 'navigate', route: '/inverters/abc123', params: {...}, message: '...' }
      - { action: 'query', data: {...}, message: '...' }
      - { action: 'action', message: '...' }
      - { action: 'unknown', message: '...' }
    """
    return await process_agent_command(request.text)
