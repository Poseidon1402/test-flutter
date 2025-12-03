# Test Flutter

An e-commerce style Flutter app showcasing a modern dark/glass UI, real‑time features, and a maintainable feature‑folder architecture.

## Overview
- Purpose: Demonstrate clean Flutter architecture, componentized screens, and real‑time viewer tracking for live events.
- Platforms: Android, iOS, Web.
- Key Features:
	- Live event screen with real‑time viewer count (Socket.IO).
	- Cart, Checkout, Login, Product Detail, Profile screens.
	- Feature‑folder structure with per‑screen components (Dart `part` files).
	- Consistent glassmorphic/dark theme and reusable UI components.

## Project Structure
- `lib/`
	- `main.dart`: App bootstrap and routing.
	- `screens/`
		- `home/`, `cart/`, `live_event/`, `login/`, `product/`, `profile/`, `checkout/`: Each screen grouped with `components/` and `part` files.
	- `blocs/`: State management (e.g., `CartBloc`, `LiveEventBloc`, `AuthBloc`, `OrdersBloc`).
	- `utils/`: Helpers and formatters (e.g., card number/expiry input formatters).
- `docs/`: Additional documentation and mock data references.
- `web/`: Web app shell (index, manifest, icons).
- `test/`: Widget tests and basic verification.

## Architecture
- **Routing**: `go_router` (or Navigator) drives navigation across feature screens.
- **State Management**: BLoC pattern for cart, auth, live events, chat, and orders.
- **Real‑Time**: Socket.IO client integrates with backend (e.g., FastAPI/python‑socketio) using events `watch_live`, `leave_live`, and room‑scoped `viewer_count` updates.
- **UI System**: Reusable components and themed widgets, extracted into `components/` per screen with Dart `part` files to keep files small and focused.
- **Testing**: Widget tests for critical flows; analyzer keeps code health high.

## Setup
Prerequisites:
- Flutter SDK (3.x+ recommended)
- Dart (comes with Flutter)
- Android/iOS tooling as needed (Android Studio/Xcode)

Install dependencies:
```bash
flutter pub get
```

Run on a device/emulator:
```bash
flutter run
```

Run tests:
```bash
flutter test
```

Web (optional):
```bash
flutter run -d chrome
```

## Environments
- Dev: Uses mock or simple API/mocked data found in `docs/` or `assets/`.
- Prod (example): Point Socket.IO client and API base URLs to your backend.

Configure environment variables (example):
- `API_BASE_URL`: REST/GraphQL endpoint
- `SOCKET_URL`: Socket.IO server URL

## Backend (Socket.IO) Setup
The live event viewer count uses a Socket.IO backend. For development:

- Use any Socket.IO-capable server (Node.js, FastAPI, etc.).
- Expose a URL such as `http://localhost:8000` and enable CORS.
- Implement two events: `watch_live` and `leave_live` per `live_id`.
- Broadcast `viewer_count` updates to the `live_id` room.

Client integration:
- Set `SOCKET_URL` (e.g., `http://localhost:8000`).
- On entering a live event, emit `watch_live` with `{ live_id }`.
- On leaving/dispose, emit `leave_live`.
- Subscribe to `viewer_count` and update state via BLoC.

### Using the included backend
This repo includes a reference backend in `backend/`.

- Location: `backend/` (files: `main.py`, `requirements.txt`)
- Purpose: Provides Socket.IO endpoints compatible with the app’s live event features.

Setup and run:
```bash
# From the repo root
cd backend
python -m venv .venv
source .venv/Scripts/activate
pip install -r requirements.txt

# Run the server (adjust host/port if needed)
python main.py
```

Then set `SOCKET_URL` in the Flutter app to match the backend URL (e.g., `http://localhost:8000`).

## Screenshots
- Add screenshots in `docs/` and reference them here.
	- Home: `docs/screens/home.png`
	- Live Event: `docs/screens/live_event.png`
	- Product Detail: `docs/screens/product_detail.png`
	- Cart & Checkout: `docs/screens/checkout.png`

## Demo Video
- Place demo video in `docs/demo/` and link: `docs/demo/demo.mp4`
- Optional YouTube/Vimeo link: `<your public demo link>`

## Notable Details
- **Checkout**: Card/expiry input formatters ensure `NNNN NNNN NNNN NNNN` and `MM/YY` patterns while typing, with Luhn validation.
- **Profile**: Orders list renders status badges and dates; loads via `OrdersBloc`.
- **Live Event**: Viewer counts are updated via dedicated `watch_live` and `leave_live` events; UI reacts in real‑time.

## Development Tips
- Keep components small; prefer `components/` + `part` per screen.
- Validate with analyzer frequently and run `flutter test`.
- Use meaningful widget names; avoid monolithic screens.
