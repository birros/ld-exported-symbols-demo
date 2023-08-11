FROM debian:bookworm

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        gcc \
        libc6-dev \
        make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
