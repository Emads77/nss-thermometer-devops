version: '3.8'

services:
    # PostgreSQL Database
    db:
        image: postgres:13
        container_name: postgres
        environment:
            POSTGRES_DB: nss_thermometer
            POSTGRES_USER: laravel
            POSTGRES_PASSWORD: secret
        volumes:
            - postgres-data:/var/lib/postgresql/data
        ports:
            - "5432:5432"
        healthcheck:
            test: ["CMD-SHELL", "pg_isready -U laravel"]
            interval: 10s
            timeout: 5s
            retries: 5

    # Laravel Backend with Nginx
    backend:
        build:
            context: ./backend
            dockerfile: Dockerfile
        container_name: backend
        volumes:
            - ./backend:/var/www/html
            # Add nginx configuration volume
            - ./backend/nginx.conf:/etc/nginx/nginx.conf
        environment:
            # Production environment variables
            APP_ENV: production
            APP_DEBUG: "false"
            DB_CONNECTION: pgsql
            DB_HOST: db
            DB_PORT: 5432
            DB_DATABASE: nss_thermometer
            DB_USERNAME: laravel
            DB_PASSWORD: secret
        depends_on:
            db:
                condition: service_healthy
        healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost/up"]
            interval: 10s
            timeout: 5s
            retries: 5
        ports:
            - "80:80"
        # Use a production-ready command or CMD in Dockerfile

    # Seeder Container
    seed:
        build:
            context: ./seed-application
            dockerfile: Dockerfile
        container_name: seeder
        depends_on:
            backend:
                condition: service_healthy
        environment:
            BACKEND_URL: http://backend
            # Add more environment variables as needed

volumes:
    postgres-data:

networks:
    default:
        driver: bridge


