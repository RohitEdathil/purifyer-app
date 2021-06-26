import asyncio
import websockets
from os import system, environ
from json import loads, dumps
HOST = ""
PORT = environ["PORT"]
system('cls')

client = None
device = None
logger = None


async def log(*args):
    s = ''
    for i in args:
        s += str(i)
    if logger != None:
        try:
            await logger.send(s)
        except Exception as e:
            print(e)


async def register(message: dict, websocket: websockets.WebSocketServerProtocol):
    if message[1] == 'device':
        global device
        device = websocket
        await log(websocket.remote_address, "Registered as Device")
    elif message[1] == 'logger':
        global logger
        logger = websocket
        await log(websocket.remote_address, "Registered as Logger")
    else:
        global client
        client = websocket
        await log(websocket.remote_address, "Registered as Client")


async def error(message: dict, websocket: websockets.WebSocketServerProtocol):
    global client
    if client != None:
        await log('Device ---error----> Client :', message[1])
        await client.send(dumps(message))
    else:
        await log('Device ---error--> [Client Inactive] :', message[1])


async def update(message: dict, websocket: websockets.WebSocketServerProtocol):
    global client
    if client != None:
        await log('Device ---update--> Client :', message[1])
        await client.send(dumps(message))
    else:
        await log('Device ---update--> [Client Inactive] :', message[1])


async def get_time(message: dict, websocket: websockets.WebSocketServerProtocol):
    global client
    if client != None:
        await log('Device ---time----> Client :', message[1])
        await client.send(dumps(message))
    else:
        await log('Device ---time--> [Client Inactive] :', message[1])


async def request(message: dict, websocket: websockets.WebSocketServerProtocol):
    global device
    if device != None:
        await log('Device <--request-- Client :', message[1])
        await device.send(dumps(message))
    else:
        await log('[Device Inactive] <--request-- Client :', message[1])


async def set_value(message: dict, websocket: websockets.WebSocketServerProtocol):
    global device
    if device != None:
        await log('Device <--set------ Client :', message[1], message[2])
        await device.send(dumps(message))
    else:
        await log('[Device Inactive] <--set---- Client :', message[1], message[2])


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
        await log(websocket.remote_address, ": Connected")
    async for message in websocket:
        await handle(message, websocket)

asyncio.get_event_loop().run_until_complete(
    websockets.serve(run, HOST, PORT))
asyncio.get_event_loop().run_forever()
