FROM alpine
COPY --from=trajano/alpine-libfaketime  /faketime.so /lib/faketime.so
ENV LD_PRELOAD=/lib/faketime.so
