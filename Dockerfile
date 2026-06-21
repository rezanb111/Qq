FROM earnfm/earnfm-client:latest AS earnfm-source

FROM alpine:latest
RUN apk update && apk add --no-cache \
    curl \
    ca-certificates \
    bash \
    libc6-compat \
    gcompat

RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -L https://github.com/traffmonetizer/cli_v2/releases/latest/download/traffmonetizer-cli-linux-x64 -o /usr/local/bin/traffmonetizer; \
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        curl -L https://github.com/traffmonetizer/cli_v2/releases/latest/download/traffmonetizer-cli-linux-arm64 -o /usr/local/bin/traffmonetizer; \
    fi && \
    chmod +x /usr/local/bin/traffmonetizer

COPY --from=earnfm-source /earnfm-client /usr/local/bin/earnfm
RUN chmod +x /usr/local/bin/earnfm

RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -L https://packetstream.io/downloads/psclient-linux-amd64 -o /usr/local/bin/psclient; \
    elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then \
        curl -L https://packetstream.io/downloads/psclient-linux-arm64 -o /usr/local/bin/psclient; \
    fi && \
    chmod +x /usr/local/bin/psclient

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
