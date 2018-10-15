FROM alpine/git
RUN git clone https://github.com/wolfcw/libfaketime /libfaketime \
 && apk -U add build-base
WORKDIR /libfaketime
RUN make \
 && make install

# Library is in
# - /usr/local/lib/faketime/libfaketimeMT.so.1
# - /usr/local/lib/faketime/libfaketime.so.1

# Build the image just to store the file

FROM scratch
COPY --from=0 /usr/local/lib/faketime/libfaketimeMT.so.1 /faketime.so

# Verify in Alpline

FROM alpine
COPY --from=1 /faketime.so /lib/faketime.so
ENV LD_PRELOAD=/lib/faketime.so
ENV FAKETIME="-15d" 
ENV DONT_FAKE_MONOTONIC=1
RUN date

# Verify with Java

FROM groovy:alpine
COPY --from=1 /faketime.so /lib/faketime.so
ENV LD_PRELOAD=/lib/faketime.so
ENV FAKETIME="-15d" 
ENV DONT_FAKE_MONOTONIC=1
RUN groovy -e "new Date();"

# Build the final image
FROM scratch
COPY --from=0 /usr/local/lib/faketime/libfaketimeMT.so.1 /faketime.so
