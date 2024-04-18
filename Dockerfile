# Stage 1: Build the Node.js application
FROM node:18.19.1 AS builder

WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Setup NGINX to serve the application
FROM nginx:latest

# Copy the built application from the previous stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for NGINX
EXPOSE 80

# Start NGINX
CMD ["nginx", "-g", "daemon off;"]

