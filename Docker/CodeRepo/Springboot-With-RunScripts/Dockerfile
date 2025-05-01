# Use Ubuntu as a base image
#FROM ubuntu:latest

# Install OpenJDK and other dependencies
#RUN apt-get update && apt-get install -y openjdk-17-jdk dos2unix

FROM openjdk:17-alpine

RUN apk add --no-cache bash

# Set the working directory in the container
WORKDIR /app

# Copy the Spring Boot JAR file from the target directory to the container
COPY target/Springboot-With-RunScripts-0.0.1-SNAPSHOT.jar /app/my-spring-boot-app.jar


# Copy the entrypoint.sh script to the container
COPY start.sh /app/

# Make the entrypoint.sh script executable
RUN chmod +x /app/start.sh && dos2unix /app/start.sh

# Expose the port the app runs on
EXPOSE 8080

# Set the entry point to the entrypoint.sh script
#ENTRYPOINT ["/app/start.sh"]
ENTRYPOINT ["/bin/bash", "/app/start.sh"]