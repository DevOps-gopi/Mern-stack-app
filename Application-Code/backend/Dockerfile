# Stage 1: Install dependencies in a full Node.js image
FROM node:14 AS build

WORKDIR /usr/src/app

# Copy package.json and package-lock.json first to cache npm install
COPY package*.json ./

# Install dependencies
RUN npm install

# Stage 2: Use a smaller Node.js runtime image
FROM node:14-slim

WORKDIR /usr/src/app

# Copy only the installed node_modules and package files from the first stage
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./

# Copy the rest of the application source code
COPY . .

# Start the application
CMD ["node", "index.js"]
