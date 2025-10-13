# Multi-stage Dockerfile to build resume PDF and Vue site

# Stage 1: Build the resume PDF using Typst
FROM ghcr.io/typst/typst:v0.13.1 AS resume-builder


# Install fontconfig to manage fonts
RUN apk add --no-cache fontconfig

WORKDIR /resume

# Copy resume files
COPY resume/ .

# Install custom fonts to system fonts directory
RUN mkdir -p /usr/share/fonts/truetype/custom && \
    cp fonts/*.otf /usr/share/fonts/truetype/custom/ && \
    fc-cache -fv

# Compile the resume
RUN typst compile cv.typ cv.pdf

# Stage 2: Build Vue frontend
FROM node:22-alpine AS frontend-builder

WORKDIR /app

# Copy package files
COPY frontend/package*.json frontend/pnpm-lock.yaml* ./

# Install pnpm and dependencies
RUN npm install -g pnpm && \
    pnpm install --frozen-lockfile

# Copy frontend source code
COPY frontend/ .

# Copy the resume PDF from resume-builder stage
COPY --from=resume-builder /resume/cv.pdf ./public/resume.pdf

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
