#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker

echo "${CONTAINER_TOKEN}" | docker login -u "${CONTAINER_USERNAME}" --password-stdin "${CI_REGISTRY}"

docker pull "${public_image_repo}:${docker_image_tag}"

docker rm -f nss-backend || true

docker run -d --name nss-backend -p 8000:8000 \
  -e DB_CONNECTION=pgsql \
  -e DB_HOST="${db_host}" \
  -e DB_PORT=5432 \
  -e DB_DATABASE="${db_name}" \
  -e DB_USERNAME="${db_username}" \
  -e DB_PASSWORD="${db_password}" \
  "${public_image_repo}:${docker_image_tag}" \
  sh -c "php artisan serve --host=0.0.0.0 --port=8000"

docker exec nss-backend php artisan migrate --force