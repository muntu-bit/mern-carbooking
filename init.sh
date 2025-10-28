#!/usr/bin/env bash
set -euo pipefail

# ----- Config -----
BACKEND_DIR="car-booking-backend"
FRONTEND_DIR="car-booking-frontend-tailwind"
MONGO_CONTAINER="carbook-mongo"
MONGO_IMAGE="mongo:7"
BACKEND_PORT=4000
FRONTEND_PORT=5173

echo "==> MERN init starting..."

# ----- Check directories -----
if [[ ! -d "$BACKEND_DIR" ]]; then
  echo "ERROR: Backend directory '$BACKEND_DIR' not found. Place this script next to $BACKEND_DIR and $FRONTEND_DIR."
  exit 1
fi
if [[ ! -d "$FRONTEND_DIR" ]]; then
  echo "ERROR: Frontend directory '$FRONTEND_DIR' not found. Place this script next to $BACKEND_DIR and $FRONTEND_DIR."
  exit 1
fi

# ----- Backend: install & env -----
echo "==> Installing backend deps..."
pushd "$BACKEND_DIR" >/dev/null
npm install

if [[ ! -f ".env" && -f ".env.example" ]]; then
  cp .env.example .env
  echo "==> Created backend .env from example"
fi
popd >/dev/null

# ----- Frontend: install & env -----
echo "==> Installing frontend deps..."
pushd "$FRONTEND_DIR" >/dev/null
npm install

if [[ ! -f ".env" && -f ".env.example" ]]; then
  cp .env.example .env
  echo "==> Created frontend .env from example"
fi
popd >/dev/null

# ----- Start MongoDB (Docker) if not running -----
if command -v docker >/dev/null 2>&1; then
  if ! docker ps --format '{{.Names}}' | grep -q "^${MONGO_CONTAINER}$"; then
    if docker ps -a --format '{{.Names}}' | grep -q "^${MONGO_CONTAINER}$"; then
      echo "==> Starting existing Mongo container ${MONGO_CONTAINER}..."
      docker start "${MONGO_CONTAINER}" >/dev/null
    } else
      echo "==> Running Mongo container ${MONGO_CONTAINER}..."
      docker run -d --name "${MONGO_CONTAINER}" -p 27017:27017 "${MONGO_IMAGE}" >/dev/null
    fi
  else
    echo "==> Mongo container ${MONGO_CONTAINER} already running."
  fi
else
  echo "!! docker not found. Ensure a local MongoDB is running on mongodb://localhost:27017"
fi

# ----- Seed cars -----
echo "==> Seeding cars..."
pushd "$BACKEND_DIR" >/dev/null
npm run seed:cars || echo "⚠️  Seeding skipped (script missing?)"
popd >/dev/null

cat <<NOTE

✅ Init complete! Next:
- Run ./dev.sh to start both servers, or run them separately:

  Backend:  (cd ${BACKEND_DIR} && npm run dev)    → http://localhost:${BACKEND_PORT}
  Frontend: (cd ${FRONTEND_DIR} && npm run dev)   → http://localhost:${FRONTEND_PORT}

NOTE
