import asyncio
import sys
import websockets
import socket
from os import system
from json import loads, dumps
HOST = socket.gethostbyname(socket.gethostname())
PORT = 8080
system('cls')

client = None
device = None


def register(message: dict, websocket: websockets.WebSocketServerProtocol):
    if message[1] == 'device':
        global device
        device = websocket
        print(websocket.remote_address, "Registered as Device")
    else:
        global client
        client = websocket
        print(websocket.remote_address, "Registered as Client")


def update(message: dict, websocket: websockets.WebSocketServerProtocol):
    global client
    if client != None:
        print('Device +-(update)--> Client :', message[1])
    else:
        print('Device +-(update)--> [Client Inactive] :', message[1])


command_map = {
    'register': register,
    'update': update,
}


def handle(message: str, websocket: websockets.WebSocketServerProtocol):
    message = loads(message)
    command_map.get(message[0], lambda a, b: print(
        f'{b.remote_address} : Invalid Message'))(message, websocket)


async def run(websocket: websockets.WebSocketServerProtocol, path: str):
    if websocket.state == 1:
        print(websocket.remote_address, ": Connected")
    async for message in websocket:
        handle(message, websocket)

print(f"Running @: ws://{HOST}:{PORT}")
asyncio.get_event_loop().run_until_complete(
    websockets.serve(run, HOST, PORT))
asyncio.get_event_loop().run_forever()
