# Stage 1: Install dependencies
FROM node:14 AS build

WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Stage 2: Create a smaller runtime image
FROM node:14-slim

WORKDIR /usr/src/app

# Copy only the necessary files from the build stage
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/package*.json ./

# Copy the rest of the application source code
COPY . .

# Start the application
CMD [ "npm", "start" ]
