#!/bin/bash
apt-get update -y
apt-get install -y docker.io
systemctl enable docker
systemctl start docker


docker login -u gitlab-ci-token -p ${CI_JOB_TOKEN} ${CI_REGISTRY}
# Pull from public registry
docker pull ${public_image_repo}:${docker_image_tag}

# Run the container on port 8000
docker run -d --name nss-backend -p 8000:8000 \
  -e DB_CONNECTION=pgsql \
  -e DB_HOST=${db_host} \
  -e DB_PORT=5432 \
  -e DB_DATABASE=${db_name} \
  -e DB_USERNAME=${db_username} \
  -e DB_PASSWORD=${db_password} \
  ${public_image_repo}:${docker_image_tag}

docker exec nss-backend php artisan migrate --force