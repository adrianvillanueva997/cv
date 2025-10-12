# Multi-stage Dockerfile to build Vue site with locally compiled CV

# Stage 1: Build Vue frontend
FROM node:20-alpine AS frontend-builder

WORKDIR /app

# Copy package files
COPY frontend/package*.json frontend/pnpm-lock.yaml* ./

# Install pnpm and dependencies
RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile

# Copy frontend source code
COPY frontend/ .

# Copy the locally compiled resume PDF
COPY resume/cv.pdf ./public/resume.pdf

# Build the Vue application
RUN pnpm run build

# Stage 3: Production image with nginx
FROM nginx:1.25-alpine AS production

# Copy built assets from frontend-builder
COPY --from=frontend-builder /app/dist /usr/share/nginx/html

# Copy custom nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
