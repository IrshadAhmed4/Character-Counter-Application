# -----------------------------
# Stage 1: Build Frontend
# -----------------------------
FROM node:18 AS frontend-builder

WORKDIR /app/frontend

# Copy frontend files
COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build

# -----------------------------
# Stage 2: Build Backend
# -----------------------------
FROM node:18 AS backend-builder

WORKDIR /app/backend

# Copy backend files
COPY backend/package*.json ./
RUN npm install --production

COPY backend/ ./

# -----------------------------
# Stage 3: Final Runtime Image
# -----------------------------
FROM node:18-alpine

WORKDIR /app

# Copy backend files
COPY --from=backend-builder /app/backend ./

# Copy built frontend static files into backend's public folder
COPY --from=frontend-builder /app/frontend/build ./public

# Expose backend port (adjust if needed)
EXPOSE 5000

# Start backend (which serves frontend too)
CMD ["node", "server.js"]
