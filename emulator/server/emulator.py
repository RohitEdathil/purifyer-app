import asyncio
import websockets
import socket
from json import loads, dumps
HOST = socket.gethostbyname(socket.gethostname())
PORT = 8080

client = None
device = None


def handle(message: str, websocket: websockets.WebSocketServerProtocol):
    data = loads(message)
    print(data)


async def run(websocket: websockets.WebSocketServerProtocol, path: str):
    if websocket.state == 1:
        print(websocket.remote_address, " : Connected")
    async for message in websocket:

        await websocket.send(message)


print(f"Running @: ws://{HOST}:{PORT}")
asyncio.get_event_loop().run_until_complete(
    websockets.serve(run, HOST, PORT))
asyncio.get_event_loop().run_forever()
