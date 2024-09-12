# Use the official Node.js image as the base image
FROM node:14 AS build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Use a lightweight web server image to serve the static files
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80

# Optionally, you can configure Nginx with your own config
# COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "start"]

