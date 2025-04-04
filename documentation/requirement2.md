
## Dockerfile Implementations

### Backend Container

The **backend Dockerfile** is structured as a multi-stage build:
1. **Vendor Stage:**  
   - **Base Image:** `composer:2.6`
   - **Purpose:** Install PHP dependencies with Composer, excluding development packages, and optimize the autoloader.
   - **Outcome:** This stage results in a `vendor` directory with only production dependencies.
   
   ```dockerfile
   FROM composer:2.6 AS vendor
   WORKDIR /app
   COPY . .
   RUN composer install --no-dev --optimize-autoloader
   ```

2. **Application Stage:**
    - **Base Image:** `php:8.2-fpm-alpine`
    - **Setup:**
        - Installs necessary packages like `postgresql-dev`, `zip`, `unzip`, and `bash`.
        - Installs and enables the `pdo_pgsql` extension to connect with PostgreSQL.
    - **Working Directory:** `/var/www/html`
    - **Copying Files:**
        - Copies the `vendor` directory from the previous stage.
        - Copies the remaining application files.
    - **Permissions:** Sets appropriate file permissions for storage and cache directories.
    - **Port & CMD:** Exposes port 9000 and runs `php-fpm`.

   ```dockerfile
   FROM php:8.2-fpm-alpine
   RUN apk add --no-cache postgresql-dev zip unzip bash
   RUN docker-php-ext-install pdo_pgsql && docker-php-ext-enable pdo_pgsql
   WORKDIR /var/www/html
   COPY --from=vendor /app/vendor ./vendor
   VOLUME ["/var/www/html/vendor"]
   COPY . .
   RUN chmod -R 755 storage bootstrap/cache && chown -R www-data:www-data storage bootstrap/cache
   EXPOSE 9000
   CMD ["php-fpm"]
   ```

### Backend Nginx Configuration

The **nginx configuration file** (used in the `backend-nginx` container) is provided to:
- Serve the Laravel application from the `public` directory.
- Forward PHP requests to the `php-fpm` container.

```nginx
server {
    listen 80;
    server_name _;
    root /var/www/html/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass php-fpm:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }
}
```

### Frontend Container

The **frontend Dockerfile** uses a two-stage build:
1. **Build Stage:**
    - **Base Image:** `node:18-alpine`
    - **Purpose:** Installs dependencies and builds the production assets using the build command (`npm run build`).
    - **Argument:** `VITE_API_URL` is provided for configuring the API endpoint.

   ```dockerfile
   FROM node:18-alpine AS build
   WORKDIR /app
   ARG VITE_API_URL
   COPY . .
   RUN npm install
   RUN npm run build
   ```

2. **Production Stage:**
    - **Base Image:** `nginx:stable-alpine`
    - **Setup:**
        - Removes the default Nginx site.
        - Copies the built assets from the build stage into Nginx's web directory.
    - **Port & CMD:** Exposes port 80 and starts Nginx.

   ```dockerfile
   FROM nginx:stable-alpine
   RUN rm -rf /usr/share/nginx/html/*
   COPY --from=build /app/dist /usr/share/nginx/html
   EXPOSE 80
   CMD ["nginx", "-g", "daemon off;"]
   ```

### Seeder Container

The seeder Dockerfile is built from a Debian slim image. It sets up the environment needed to run the seeding script that populates the backend with initial data.

**Setup:**

-   **Tools Installation:**  
    The Dockerfile installs necessary tools such as `curl` and `bash` using `apt-get`. These are required to execute the seeding script and perform HTTP requests to the backend.

-   **File Copying:**  
    It copies the `add_data.sh` script and the `data.md` file into the container’s working directory, which is set to `/app`.

-   **Environment Variable:**  
    An environment variable, `BACKEND_URL`, is set to `http://backend:8000` as a default value.

    -   _Note:_ This value is hardcoded in the Dockerfile for convenience. However, it can easily be overridden using external mechanisms such as Docker Compose or the `-e` flag with `docker run`. This makes the REST endpoint configurable without needing to modify the Dockerfile itself.
- **CMD:** Executes the seeding script.

```dockerfile
FROM debian:bullseye-slim
RUN apt-get update && apt-get install -y curl bash && apt-get clean
WORKDIR /app
COPY add_data.sh .
COPY data.md .
RUN chmod +x add_data.sh
ENV BACKEND_URL=http://backend:8000
CMD ["./add_data.sh", "data.md"]
```

---

## Docker Compose Configuration

The **docker-compose.yml** file orchestrates the multi-container application. Key points include:

- **Services Defined:**
    - **db:** Uses the official PostgreSQL image with environment variables for database configuration. A health check using `pg_isready` ensures the database is ready before dependent services start.
    - **php-fpm:** Builds the backend container, mounts necessary volumes, and depends on the `db` service.
    - **backend-nginx:** Runs the Nginx server to serve the backend application. It depends on `php-fpm` and includes a health check using `curl`.
    - **frontend:** Builds the frontend container and depends on the `backend-nginx` service.
    - **seed:** Builds the seeder container, which depends on the backend being healthy.

- **Networks:**
    - **internal:** For inter-service communication (private network).
    - **public:** For exposing certain services externally.

- **Volumes:**
    - Persistent storage for PostgreSQL data and shared vendor data are defined.

---

## Build, Run, and Stop Script

A Bash script is planned to simplify the following tasks:
- **Build:** Create Docker images for all services.
- **Run:** Start all containers via Docker Compose.
- **Stop:** Gracefully stop the running containers.


The script will use Docker Compose commands such as:
- `docker-compose build`
- `docker-compose up -d`
- `docker-compose down`

---

## Environment Variables and .env Files

Environment variables are critical for configuration. The setup includes:
- Passing variables to Docker builds (e.g., `VITE_API_URL` for the frontend).
- Specifying database connection details for the backend.
- Configuring the `BACKEND_URL` for the seeder.

These variables can be managed via a `.env` file and referenced in the Docker Compose file using variable substitution.

---

## Health Check Mechanisms & Boot Order

To ensure the correct boot order:
- **Database Health Check:**  
  The PostgreSQL service uses a health check with `pg_isready` to confirm readiness before dependent services start.
- **Backend Health Check:**  
  The backend-nginx container uses a health check with `curl` to validate that the web server is responding.
- **Depends_On:**  
  The Docker Compose file uses `depends_on` with conditions (e.g., `service_healthy` and `service_started`) to enforce the correct startup sequence.

---

## Multi-stage Builds & Dockerignore

**Multi-stage builds** are used in the backend and frontend Dockerfiles to reduce image size and ensure that only production-ready code is included.  
**.dockerignore:**  
A `.dockerignore` file is used to exclude unnecessary files from the Docker context, ensuring that temporary or development files do not end up in the final image.

---

## Conclusion

This containerization approach:
- **Isolates** each component (backend, frontend, database, seeder) into its own container.
- **Enables** easy scaling and management using Docker Compose.
- **Ensures** proper startup order and health checks for reliable operation.
- **Provides** a convenient script (to be implemented) for building, running, and stopping the containers.

By following these practices, the application is both modular and maintainable, aligning with the DevOps principles required for the assignment.

---

## References

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Laravel Deployment Guide](https://laravel.com/docs/deployment)

```

