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

# Track viewer counts per room (only watchers counted)
viewer_counts: dict[str, int] = {}
# Track which sids are actively watching each room
watchers_by_room: dict[str, set[str]] = {}


@sio.event
async def connect(sid, environ):
    print(f"Client connected: {sid}")


@sio.event
async def disconnect(sid):
    print(f"Client disconnected: {sid}")
    # Decrement viewer count only for rooms this sid is watching
    try:
        rooms_to_update = [
            room for room, watchers in watchers_by_room.items() if sid in watchers
        ]
        for room in rooms_to_update:
            watchers = watchers_by_room.get(room, set())
            if sid in watchers:
                watchers.remove(sid)
                watchers_by_room[room] = watchers
                viewer_counts[room] = len(watchers)
                await sio.emit(
                    "viewer_count",
                    {"room": room, "count": viewer_counts[room]},
                    room=room,
                )
    except Exception as e:
        print(f"Error updating viewer counts on disconnect: {e}")


# Basic chat namespace / events
@sio.event
async def join(sid, data):
    room = data.get("room")
    username = data.get("username")
    print(f'Join room: {room}, username: {username}')
    if room:
        await sio.enter_room(sid, room)
        await sio.emit(
            "system",
            {"message": f"{username or 'Someone'} joined room {room}"},
            room=room,
        )


# Watching live events (separate from chat join)
@sio.event
async def watch_live(sid, data):
    room = data.get("room")
    username = data.get("username")
    print(f'Watch live: room={room}, username={username}')
    if not room:
        return
    # Ensure the watcher is in the room to receive updates
    await sio.enter_room(sid, room)
    watchers = watchers_by_room.get(room)
    if watchers is None:
        watchers = set()
    if sid not in watchers:
        watchers.add(sid)
        watchers_by_room[room] = watchers
        viewer_counts[room] = len(watchers)
        # Emit viewer count only to the room
        await sio.emit(
            "viewer_count",
            {"room": room, "count": viewer_counts[room]},
            room=room,
        )


@sio.event
async def leave_live(sid, data):
    room = data.get("room")
    print(f'Leave live: room={room}')
    if not room:
        return
    watchers = watchers_by_room.get(room)
    if not watchers:
        return
    if sid in watchers:
        watchers.remove(sid)
        watchers_by_room[room] = watchers
        viewer_counts[room] = len(watchers)
        await sio.emit(
            "viewer_count",
            {"room": room, "count": viewer_counts[room]},
            room=room,
        )


@sio.event
async def message(sid, data):
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
