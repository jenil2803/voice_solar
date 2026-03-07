import asyncio
from config.database import client

async def test():
    try:
        print(await client.server_info())
        print("Success")
    except Exception as e:
        print(f"Error: {e}")

asyncio.run(test())
