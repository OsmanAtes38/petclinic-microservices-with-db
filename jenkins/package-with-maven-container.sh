#!/bin/bash

# Variables
CONTAINER_NAME=maven-build-container
DOCKER_IMAGE=maven:3.8.6-jdk-11  # Specify the Maven image and JDK version
PROJECT_DIR=$(pwd)  # Current directory (project root where pom.xml exists)
TARGET_DIR=target

# Check if target directory exists, if so, remove it to avoid conflicts
if [ -d "$TARGET_DIR" ]; then
  echo "Removing existing target directory..."
  rm -rf $TARGET_DIR
fi

# Pull Maven Docker image
echo "Pulling Docker image: $DOCKER_IMAGE..."
docker pull $DOCKER_IMAGE

# Run Maven inside Docker container
echo "Packaging the Maven project inside Docker container..."
docker run --rm --name $CONTAINER_NAME \
  -v $PROJECT_DIR:/usr/src/mymaven \
  -v $HOME/.m2:/root/.m2 \
  -w /usr/src/mymaven \
  $DOCKER_IMAGE mvn clean package

# Check if the package was created
if [ -d "$TARGET_DIR" ]; then
  echo "Maven package has been successfully created in the target directory."
else
  echo "Packaging failed."
fi
