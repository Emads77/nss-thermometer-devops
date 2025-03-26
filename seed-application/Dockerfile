# Use a lightweight base image with curl and bash
FROM debian:bullseye-slim

# Install curl and bash
RUN apt-get update && apt-get install -y curl bash && apt-get clean

# Set working directory
WORKDIR /app

# Copy script and data file
COPY add_data.sh .
COPY data.md .

# Make the script executable
RUN chmod +x add_data.sh

# Set environment variable (you can override this at runtime)
ENV BACKEND_URL=http://backend:8000

# Run the script by default
CMD ["./add_data.sh", "data.md"]
