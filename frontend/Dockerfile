FROM node:16-alpine AS build

# Node
# Create app directory
WORKDIR /app

COPY . .
RUN npm install

# Build the app (production build)
RUN npm run build

# Serve with Nginx
FROM nginx:stable-alpine

# Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy built files from Stage 1
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]