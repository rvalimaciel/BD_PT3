# BD_PT3

## Running Database

Start database:
```sh
docker compose up -d && docker compose logs -f
```
The `*.sql` files in the `init/` folder will be run when a new database is created.
They won't be run when starting an existing db.
Postgres will be running in `localhost:5432`, and pgweb will be available at http://localhost:8081.

Shutdown database:
```sh
docker compose down
```

Delete database:
```sh
docker volume rm bd_pt3_postgres-data
```

## Build Application

Build the application using [maven](https://maven.apache.org/):
```sh
cd bd
mvn clean package
```

## Run the Application

Run the application:
```sh
java -jar ./bdtarget/streaming-service-agregator-1.0.x-SNAPSHOT-jar-with-dependencies.jar
```
