# Stage 1: Build frontend
FROM node:14 AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm install
COPY frontend .
RUN npm run build

# Stage 2: Build backend
FROM node:14 AS backend-build
WORKDIR /app/backend
COPY backend/package.json backend/package-lock.json ./
RUN npm install
COPY backend .
RUN npm run build

# Stage 3: Production image
FROM node:14-alpine
WORKDIR /app
COPY --from=frontend-build /app/frontend/build ./frontend
COPY --from=backend-build /app/backend ./
RUN npm install --only=production
CMD ["node", "index.js"]
