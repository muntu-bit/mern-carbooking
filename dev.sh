#!/usr/bin/env bash
set -euo pipefail

BACKEND_DIR="car-booking-backend"
FRONTEND_DIR="car-booking-frontend-tailwind"

cleanup() {
  echo ""
  echo "==> Stopping backend & frontend..."
  [[ -n "${BACK_PID-}" ]] && kill "${BACK_PID}" 2>/dev/null || true
  [[ -n "${FRONT_PID-}" ]] && kill "${FRONT_PID}" 2>/dev/null || true
  wait || true
  exit 0
}
trap cleanup INT TERM

(cd "$BACKEND_DIR" && npm run dev) & BACK_PID=$!
sleep 1
(cd "$FRONTEND_DIR" && npm run dev) & FRONT_PID=$!

echo "==> Backend PID: $BACK_PID"
echo "==> Frontend PID: $FRONT_PID"
echo "==> Press Ctrl+C to stop both."

wait -n
cleanup
