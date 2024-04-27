# Tic-tac-toe

To run the application, you need to have docker and docker-compose installed in your machine.

Then you can start it by running:

```sh
$ docker compose up
```

For the initial setup, after installing them, you need to create the databases:

```sh
$ docker compose run web rake db:create
```
