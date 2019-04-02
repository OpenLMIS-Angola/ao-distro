# OpenLMIS Angola local development env
Location for the OpenLMIS v3+ Angola local development env 

## Tech Requirements

* Docker Engine: 1.12+
* Docker Compose: 1.8+

Note that Docker on Mac and Windows hasn't always been as native as it is now with [Docker for Mac](https://www.docker.com/products/docker#/mac)
and [Docker for Windows](https://www.docker.com/products/docker#/windows).  If you're using one of these, please note that there are some known issues:

* docker compose on Windows hasn't supported our development environment setup, so you _can_ use Docker for Windows to run the Reference Distribution, but not to develop
* if you're on a Virtual Machine, finding your correct IP may have some caveats - esp for development


## Setup with database dump form UAT or DEV

1. Update .env file by copying settings from
[angola-openlmis-deployment](https://github.com/OpenLMIS-Angola/angola-openlmis-deployment/blob/master/deployment/dev_env/.env).

2. Copy and configure your settings, edit `VIRTUAL_HOST` and `BASE_URL` to be your IP address
(if you're behind a NAT, then don't mistakenly use the router's address), You __should only need
to do this once__, though as this is an actively developed application, you may need to check the
environment file template for new additions.
Before using database dump from uat or dev, you should copy settings.env associated with specific configuration.
Please keep in mid that you should edit some variables:
      ```
      BASE_URL=http://<your_IP>
      VIRTUAL_HOST=<your_IP>
      SCALYR_API_KEY= # (it will prevent from sending logs to Scalyr)
      DATABASE_URL=jdbc:postgresql://db:5432/open_lmis
      POSTGRES_PASSWORD=p@ssw0rd
      MAIL_HOST=localhost
      ```
      Note that 'localhost' will not work here—-it must be an actual IP address (like aaa.bbb.yyy.zzz).
      This is because localhost would be interpreted relative to each container, but providing your
      workstation's IP address gives an absolute outside location that is reachable from each container.
      Also note that your BASE_URL will not need the port ":8080" that may be in the environment file
      template.

3. Pull all the services Since this is actively developed, you __should pull the services frequently__.
     ```
    $ docker-compose pull
    ```

4. Import database dump.
    ```
    PGHOST=localhost
    PASS=<db_password_from_settings.env>
    DB_NAME=<db_name_from_settings.env>
    USER=<db_user_from_settings.env>
    ```
    ```
    $ docker-compose up -d db # start db
    $ PGPASSWORD=$PASS createdb -h $PGHOST -U $USER $DB_NAME &&
      PGPASSWORD=$PASS psql -h $PGHOST -U $USER $DB_NAME -c "CREATE ROLE rdsadmin NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;" &&
      PGPASSWORD=$PASS psql -h $PGHOST -U $USER $DB_NAME < <your_db_file>.sql
    $ docker-compose up -d

    ```

5. Bring the distribution up.
    ```
    $ docker-compose up -d
    ```

6. When the application is up and running, you should be able to access the Reference Distribution at:

	```
	http://<your ip-address>/
	```

	_note if_ you get a `HTTP 502: Bad Gateway`, it is probably still starting up all of the
	microservice containers.  You can wait a few minutes for everything to start.  You can also
	run `docker stats` to watch each container using CPU and memory while starting.

7. To stop the application & cleanup:

	* if you ran `docker-compose up -d`, stop the application with `docker-compose down -v`
	* if you ran `docker-compose up` _note_ the absence of `-d`, then interupt the application with `Ctrl-C`, and perform cleanup by removing containers.  See
	our [docker cheat sheet](https://openlmis.atlassian.net/wiki/x/PwBIAw) for help on manually removing containers.


## Configuring Services

When a container needs configuration via a file (as opposed to an environment variable for example), then
there is a special Docker image that's built as part of this Reference Distribution from the Dockerfile of
the `config/` directory.  This image, which will also be deployed as a container, is only a vessel for
providing a named volume from which each container may mount the `/config` directory in order to self-configure.

To add configuration:

1. Create a new directory under `config/`.  Use a unique and clear name. e.g. *kannel*.
2. Add the configuration files in this directory.  e.g. `config/kannel/kannel.config`.
3. Add a COPY statement to `config/Dockerfile` which copies the configuration file to the container's `/config`.
e.g. `COPY kannel/kannel.config /config/kanel/kannel.config`.
4. Ensure that the container which will use this configuration file mounts the named-volume `service-config` to
`/config`.  e.g.

  ```shell
  kannel:
    image: ...
    volumes:
      - 'service-config:/config'
  ```
5. Ensure the container uses/copies the configuration file from `/config/...`.
6. When you add new configuration, or change it, ensure you bring this Reference Distribution with the `--build`
flag.  e.g. `docker-compose up --build`.

The logging configuration utilizes this method.

_NOTE:_ that the configuration container that's built here doesn't _run_.  It is normal for it's Status to be
Exited.

## Logging

Logging configuration is "passed" to each service as a file (logback.config) through a named docker volume:
`service-config`.  To change the logging configuration:

1. update `config/log/logback.xml`
2. bring the application up with `docker-compose up --build`.  The `--build` option will re-build the
configuration image.

Most logging is collected by way of rsyslog (in the `log` container) which writes to the named volume: `log`.
However not every docker container logs via rsyslog to this named volume.  For these services they log either
via docker logging or to a file for which a named-volume approach works well.


#### Log format for Services

The default log format for the Services is below:

* `<timestamp> <container ID> <thread ID> <log level> <logger / Java class> <log message>`

The format from the thread ID onwards can be changed in the `config/log/logback.xml` file.
