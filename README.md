# docker-wptest

Run WordPress tests in a Docker container.

Installed WordPress versions with right test library for each versions:

```
4.4
4.4.1
4.4.2
4.4.3
4.4.4
4.4.5

4.5
4.5.1
4.5.2
4.5.3
4.5.4

4.6
4.6.1

4.7
4.7.1
4.7.2
4.7.3

latest
```

## Usage

First create a `mysql` container with user root and no password

```
docker run --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=true -d mysql:latest
```

and then you can run:

```
docker run --rm -v /path/to/plugin:/opt --link mysql frozzare/wptest:7.0 vendor/bin/phpunit
```

If you would like to test against another WordPress version add the environment variable `WP_VERSION=4.4` when you run the container.

## Contributing

Add new WordPress versions to `versions.sh` and run `update.sh` instead of adding them to each docker container and update the readme file with new versions.

## License

MIT © [Fredrik Forsmo](https://github.com/frozzare)
