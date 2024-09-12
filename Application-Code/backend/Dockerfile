# Use the official Maven image to build the application
FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app
COPY src /app/src
COPY pom.xml /app
RUN mvn clean package -DskipTests

# Use a lightweight Java runtime image for the final image
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/ransomware-backend-1.0-SNAPSHOT.jar /app/backend.jar

# Set environment variables (these should be configured in your deployment environment)
ENV DB_DATABASE=${DB_DATABASE}
ENV DB_SERVICE=${DB_SERVICE}
ENV DB_USERNAME=${DB_USERNAME}
ENV DB_PASSWORD=${DB_PASSWORD}

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/backend.jar"]
