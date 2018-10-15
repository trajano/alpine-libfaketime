Alpine libfaketime
==================
A simple image containing [libfaketime](https://github.com/wolfcw/libfaketime) built with Alpine build tools for use with multistage builds.

The intent of this project is to be used in [Docker multistage builds](https://docs.docker.com/develop/develop-images/multistage-build/) to add faketime support to your containers for local testing.

Only the multithreaded version is used and stored as `/faketime.so`.

## Usage

The `Dockerfile` used to build shows how the image is built and tested.  However to use it in a multisage build the `Dockerfile` using the `COPY --from=trajano/alpine-libfaketime` and setting the proper environment variables. 

### With simple command line apps

    FROM alpine
    COPY --from=trajano/alpine-libfaketime  /faketime.so /lib/faketime.so
    ENV LD_PRELOAD=/lib/faketime.so

Then build and pass the `FAKETIME` environment variable when doing a `docker run` for example

    docker build -f fakedemo.Dockerfile . -t fakedemo
    docker run --rm -e FAKETIME=+15d fakedemo date

### With Java

For example purposes [groovy](https://hub.docker.com/_/groovy/) was used as it is a JVM language that allows us to pass a simple script to run from the command line.  The key thing to note is that the `DONT_FAKE_MONOTONIC=1` environment variable should be set as documented in [libfaketime](https://github.com/wolfcw/libfaketime).

    FROM groovy:alpine
    COPY --from=trajano/alpine-libfaketime  /faketime.so /lib/faketime.so
    ENV LD_PRELOAD=/lib/faketime.so \
        DONT_FAKE_MONOTONIC=1

Then build and pass the `FAKETIME` environment variable when doing a `docker run` for example

    docker build -f fakedemo-java.Dockerfile . -t fakedemo
    docker run --rm -e FAKETIME=+15d fakedemo groovy -e "print new Date();"
