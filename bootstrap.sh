#!/usr/bin/env bash
set -e

echo "==> Creating project structure..."
mkdir -p car-booking-backend car-booking-frontend-tailwind

echo "==> Initializing backend (Express + Mongo)..."
cd car-booking-backend
npm init -y >/dev/null
npm install express mongoose dotenv cors helmet morgan jsonwebtoken bcrypt >/dev/null
cat > server.js <<'JS'
import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());

app.get("/", (req, res) => res.send("Backend is running"));

mongoose.connect(process.env.MONGO_URI || "mongodb://localhost:27017/car_booking_secure")
.then(()=>console.log("✅ MongoDB connected"))
.catch(err=>console.error(err));

const PORT = process.env.PORT || 4000;
app.listen(PORT, ()=>console.log("🚀 Server running on port", PORT));
JS
cd ..

echo "==> Initializing frontend (React + Tailwind + Vite)..."
npm create vite@latest car-booking-frontend-tailwind -- --template react
cd car-booking-frontend-tailwind
npm install
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
cat > tailwind.config.js <<'JS'
export default {
  content: ["./index.html", "./src/**/*.{js,jsx,ts,tsx}"],
  theme: { extend: {} },
  plugins: [],
}
JS
echo "@tailwind base;\n@tailwind components;\n@tailwind utilities;" > src/index.css
cd ..

echo "✅ Done! Next steps:"
echo "1. cd car-booking-backend && node server.js   # start backend"
echo "2. cd car-booking-frontend-tailwind && npm run dev   # start frontend"
