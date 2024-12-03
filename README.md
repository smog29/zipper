# README

## Zipper API

A Rails application providing a RESTful JSON API for managing file uploads and downloads. The app includes user authentication, zip encryption, and documentation. The app uses MySQL for the database.

### Requirements
* ruby 3.3.3
* rails 7.2.2

### Getting Started

* create a `.env` file in the root directory of the project and add the following environment variables:
  ```shell
  DATABASE_USER=<your-database-user>
  DATABASE_PASSWORD=<your-database-password>
  ```

* to run the application, execute the following commands:
  ```shell
  bundle install
  rails db:create
  rails db:migrate
  rails s
  ```

API Documentation: OpenAPI documentation is available at `/api/docs`, rendered using Swagger UI. Managing files requires user authentication. The API uses a bearer token for authentication.