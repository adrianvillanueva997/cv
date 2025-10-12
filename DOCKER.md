# Docker Build Instructions

This project uses a multi-stage Docker build to:
1. Compile the Typst resume PDF
2. Build the Vue frontend application
3. Serve everything with nginx

## Quick Start

### Using Docker Compose (Recommended)

```bash
# Build and start the container
docker-compose up -d

# View logs
docker-compose logs -f

# Stop the container
docker-compose down
```

The site will be available at: http://localhost:8080

### Using Docker directly

```bash
# Build the image
docker build -t cv-resume:latest .

# Run the container
docker run -d -p 8080:80 --name resume-site cv-resume:latest

# View logs
docker logs -f resume-site

# Stop and remove
docker stop resume-site
docker rm resume-site
```

### Using the build script

```bash
# Make sure the script is executable
chmod +x build-resume.sh

# Run the build
./build-resume.sh
```

## Build Stages

1. **Stage 1: Resume Builder**
   - Uses Typst to compile `resume/cv.typ` to `cv.pdf`
   - Base image: `ghcr.io/typst/typst:v0.11.1`

2. **Stage 2: Frontend Builder**
   - Installs dependencies with pnpm
   - Copies the resume PDF to `public/resume.pdf`
   - Builds the Vue application with Vite
   - Base image: `node:20-alpine`

3. **Stage 3: Production**
   - Serves the built site with nginx
   - Includes custom nginx configuration for:
     - Gzip compression
     - Security headers
     - Static asset caching
     - SPA routing support
   - Base image: `nginx:1.25-alpine`

## Files

- `Dockerfile` - Multi-stage build configuration
- `docker-compose.yml` - Docker Compose configuration
- `nginx.conf` - Nginx server configuration
- `.dockerignore` - Files excluded from Docker context
- `build-resume.sh` - Convenience build script

## Production Deployment

For production deployment, you can push the image to a container registry:

```bash
# Build for production
docker build -t your-registry/cv-resume:latest .

# Push to registry
docker push your-registry/cv-resume:latest

# Deploy to your server
docker pull your-registry/cv-resume:latest
docker run -d -p 80:80 --name resume-site your-registry/cv-resume:latest
```

## Environment Variables

Currently no environment variables are required, but you can add them in `docker-compose.yml` if needed.

## Health Check

The nginx configuration includes a `/health` endpoint for health checks:

```bash
curl http://localhost:8080/health
# Response: healthy
```

## Troubleshooting

### Build fails at resume stage
- Ensure your `resume/cv.typ` file is valid Typst syntax
- Check that all required fonts are in `resume/fonts/`

### Build fails at frontend stage
- Ensure `frontend/package.json` has correct dependencies
- Check that `frontend/pnpm-lock.yaml` is up to date

### Site doesn't load
- Check nginx logs: `docker logs resume-site`
- Verify the container is running: `docker ps`
- Ensure port 8080 is not already in use

## Development

For development, it's recommended to run the frontend locally:

```bash
cd frontend
pnpm install
pnpm run dev
```

And build the resume separately:

```bash
cd resume
typst compile cv.typ cv.pdf
cp cv.pdf ../frontend/public/resume.pdf
```
