# docker-wptest

> WIP!

## Usage

First create a `mysql` container with user root and no password and then you can run:

```
docker run --rm -v /path/to/plugin:/opt --link mysql frozzare/wptest:7.0 vendor/bin/phpunit
```

## License

MIT © [Fredrik Forsmo](https://github.com/frozzare)
