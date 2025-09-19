# ==========================
# Stage 1: Build Angular app
# ==========================
FROM node:18 AS build

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the Angular app in production mode
RUN npm run build --prod

# ==========================
# Stage 2: Serve with Nginx
# ==========================
FROM nginx:alpine

# Copy built Angular app from Stage 1
COPY --from=build /app/dist/test/browser /usr/share/nginx/html

# Copy custom Nginx configuration (optional but recommended for Angular routing)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 8080

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
