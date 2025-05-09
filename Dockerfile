# Build stage
FROM node:20-alpine AS build
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Fix permission issues for Vite and esbuild
RUN chmod +x node_modules/.bin/vite \
    && chmod +x node_modules/@esbuild/linux-x64/bin/esbuild

RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
