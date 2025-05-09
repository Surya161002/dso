# Build stage
FROM node:20-alpine AS build

# Install required system packages (fixes permission issues)
RUN apk add --no-cache bash

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Ensure vite biary is executable
RUN chmod +x node_modules/.bin/vite

# Run build
RUN npm run build

# Production stage
FROM nginx:alpine

# Copy built files to nginx directory
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: Add custom nginx config
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
