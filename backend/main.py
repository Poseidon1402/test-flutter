import socketio
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

sio = socketio.AsyncServer(async_mode="asgi", cors_allowed_origins="*")
app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

asgi_app = socketio.ASGIApp(sio, other_asgi_app=app)


@sio.event
async def connect(sid, environ):
    print(f"Client connected: {sid}")


@sio.event
async def disconnect(sid):
    print(f"Client disconnected: {sid}")


# Basic chat namespace / events
@sio.on("join")
async def on_join(sid, data):
    room = data.get("room")
    username = data.get("username")
    print(f'Join room: {room}, username: {username}')
    if room:
        sio.enter_room(sid, room)
        await sio.emit(
            "system",
            {"message": f"{username or 'Someone'} joined room {room}"},
            room=room,
        )


@sio.on("message")
async def on_message(sid, data):
    room = data.get("room")
    message = data.get("message")
    user_id = data.get("userId")
    username = data.get("username")

    if not room or not message:
        return
    
    payload = {
        "userId": user_id,
        "username": username,
        "message": message,
    }
    await sio.emit("message", payload)
    print(f'Message to room {room}: {payload}')


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(asgi_app, host="0.0.0.0", port=8000)
