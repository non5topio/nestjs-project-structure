# FROM node:18

# WORKDIR /app

# COPY package*.json ./
# RUN npm install

# COPY . .

# RUN npm run build

# CMD ["npm", "run", "start:prod"]


# ---------------- Base Stage ----------------
    FROM node:21 AS base

    # Install redis-server
    RUN apt-get update && apt-get install -y redis-server
    
    # Set working directory
    WORKDIR /app
    
    # Copy dependencies and install them
    COPY package*.json ./
    RUN npm install && npm install -D vitest
    
    # Copy the rest of the app
    COPY . .
    
    # ---------------- Test Stage ----------------
    FROM base AS test
    
    # Run redis-server in background and then run tests
    CMD redis-server --daemonize yes && npm run test
    
