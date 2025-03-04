# NSE Thermometer Backend

## Installation
To get this project up and running, you will need to do the following things:
1. Install PHP 8.2 or higher on your machine.
2. Install the dependency manager ([composer](https://getcomposer.org/)).
3. Install all the dependencies using `composer install`.
4. Adjust the `.env` file so that all settings are correct. While testing locally, you will use SQLite. Don't forget to setup the correct path to the database file (this needs to be an absolute path).
5. Run `php artisan migrate`. This will create the database tables for you.
6. Run `php artisan serve`. This will start the development server for you.
7. Go to [http://localhost:8000](http://localhost:8000) and test the backend manually.

## Endpoints
All endpoints have been defined with Swagger. This means that there will be documentation page available for you on [http://localhost:8000/api/documentation](http://localhost:8000/api/documentation) when the server is running.

## Health monitoring
There is one specific end-point available that can be used for checking if the backend application is running completely (also to make sure the database has been seeded). This can be done by using the url [http://localhost:8000/up](http://localhost:8000/up).

## Environments
Currently there is only one environment defined. For this exam, it is necessary to create two environments:
1. Development/testing environment: this environment should use SQLite as a database driver.
2. Production environment: this environment should use PostgreSQL as a database driver. This is also the environment that you will need to use for the docker part of this assignment.

In order to use PostgreSQL, you will need to use more environment variables: `DB_CONNECTION=pgsql`, `DB_HOST`, `DB_PORT`, `DB_DATABASE`, `DB_USERNAME` and `DB_PASSWORD`.

## Artisan commands
`artisan` is a command-line interface shipped with Laravel for developers to help with various tasks during development. It contains a development server (just like with Vite). This development server is useable during development, but should not be used for a production environment!

You could use the following `artisan` commands for this project.

- `php artisan migrate` will create the database tables for you.
- `php artisan serve` starts the backend application.
- `php artisan test` runs all of the tests from the tests folder.
- `php artisan l5-swagger:generate` create the swagger documentation (available at /api/documentation in the browser).

## Dockerizing the applicatiom
We could reuse our docker containers properly later on when deploying them to the cloud. Therefore we are aiming for a production ready docker composition. Please note: `php artisan` can be used during development, but it is not suitable for production environments! Therefore you need to find out how to run a Laravel application properly in production. This will mean that you will need two containers for the backend. One that acts as a webserver and one that acts as a php processor. Consult the laravel documentation for more information about deployment.