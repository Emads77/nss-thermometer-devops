#!/bin/bash

if [ "$#" -eq 0 ]; then
  echo "Usage: $0 {build|run|stop}"
  exit 1
fi

# Check if Docker and Docker Compose are installed
if ! command -v docker >/dev/null 2>&1; then
  echo "Error: Docker is not installed."
  exit 1
fi

if ! command -v docker-compose >/dev/null 2>&1; then
  echo "Error: Docker Compose is not installed."
  exit 1
fi

COMMAND="$1"

case "$COMMAND" in
  build)
    echo "Building Docker images..."
    docker-compose build
    if [ $? -ne 0 ]; then
      echo "Error: Docker build failed."
      exit 1
    fi
    echo "Docker images built successfully."
    ;;
  run)
    echo "Starting Docker containers..."
    docker-compose up -d
    if [ $? -ne 0 ]; then
      echo "Error: Failed to start Docker containers."
      exit 1
    fi
    echo "Docker containers are now running."
    ;;
  stop)
    echo "Stopping Docker containers..."
    docker-compose down
    if [ $? -ne 0 ]; then
      echo "Error: Failed to stop Docker containers."
      exit 1
    fi
    echo "Docker containers have been stopped and removed."
    ;;
  *)
    echo "Invalid command: $COMMAND"
    echo "Usage: $0 {build|run|stop}"
    exit 1
    ;;
esac
