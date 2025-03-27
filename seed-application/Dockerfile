FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y curl bash && apt-get clean

WORKDIR /app

COPY add_data.sh .
COPY data.md .

RUN chmod +x add_data.sh

ENV BACKEND_URL=http://backend:8000

CMD ["./add_data.sh", "data.md"]
