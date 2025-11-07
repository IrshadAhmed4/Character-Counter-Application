# -----------------------------
# Stage 1: Build Frontend
# -----------------------------
FROM node:18 AS frontend-builder

WORKDIR /app/frontend

# Copy frontend code and install dependencies
COPY frontend/package*.json ./
RUN npm install

COPY frontend/ ./
RUN npm run build


# -----------------------------
# Stage 2: Build Backend
# -----------------------------
FROM node:18 AS backend-builder

WORKDIR /app/backend

# Copy backend dependencies and install
COPY backend/package*.json ./
RUN npm install --production

# Copy backend source code
COPY backend/ ./


# -----------------------------
# Stage 3: Final Runtime Image
# -----------------------------
FROM node:18-alpine

WORKDIR /app

# Copy backend from previous build
COPY --from=backend-builder /app/backend ./

# Copy frontend build output into backend's public folder
COPY --from=frontend-builder /app/frontend/build ./public

# Expose backend port
EXPOSE 5000

# Run backend server
CMD ["node", "server.js"]
