import asyncio
import sys
import websockets
import socket
from os import system, environ
from json import loads, dumps
HOST = ""
PORT = environ["PORT"]
system('cls')

client = None
device = None


async def register(message: dict, websocket: websockets.WebSocketServerProtocol):
    if message[1] == 'device':
        global device
        device = websocket
        print(websocket.remote_address, "Registered as Device")
    else:
        global client
        client = websocket
        print(websocket.remote_address, "Registered as Client")


async def error(message: dict, websocket: websockets.WebSocketServerProtocol):
    global client
    if client != None:
        print('Device ---error----> Client :', message[1])
        await client.send(dumps(message))
    else:
        print('Device ---error--> [Client Inactive] :', message[1])


async def update(message: dict, websocket: websockets.WebSocketServerProtocol):
    global client
    if client != None:
        print('Device ---update--> Client :', message[1])
        await client.send(dumps(message))
    else:
        print('Device ---update--> [Client Inactive] :', message[1])


async def get_time(message: dict, websocket: websockets.WebSocketServerProtocol):
    global client
    if client != None:
        print('Device ---time----> Client :', message[1])
        await client.send(dumps(message))
    else:
        print('Device ---time--> [Client Inactive] :', message[1])


async def request(message: dict, websocket: websockets.WebSocketServerProtocol):
    global device
    if device != None:
        print('Device <--request-- Client :', message[1])
        await device.send(dumps(message))
    else:
        print('[Device Inactive] <--request-- Client :', message[1])


async def set_value(message: dict, websocket: websockets.WebSocketServerProtocol):
    global device
    if device != None:
        print('Device <--set------ Client :', message[1], message[2])
        await device.send(dumps(message))
    else:
        print('[Device Inactive] <--set---- Client :', message[1], message[2])


command_map = {
    'register': register,
    'update': update,
    'request': request,
    'set': set_value,
    'time': get_time,
    'error': error
}


async def handle(message: str, websocket: websockets.WebSocketServerProtocol):
    message = loads(message)
    await command_map.get(message[0])(message, websocket)


async def run(websocket: websockets.WebSocketServerProtocol, path: str):
    if websocket.state == 1:
        print(websocket.remote_address, ": Connected")
    async for message in websocket:
        await handle(message, websocket)

print(f"Running @: ws://{HOST}:{PORT}")
asyncio.get_event_loop().run_until_complete(
    websockets.serve(run, HOST, PORT))
asyncio.get_event_loop().run_forever()
