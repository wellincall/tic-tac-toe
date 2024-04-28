# Tic-tac-toe

To run the application, you need to have docker and docker-compose installed in your machine.

Then you can start it by running:

```sh
$ docker compose up
```

For the initial setup, after starting the containers, it is necessary to set the databases:

```sh
$ docker compose run web rake db:create
$ docker compose run web rake db:migrate
```
