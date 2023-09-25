FROM node:20-buster-slim

ARG ARTILLERY_VERSION=2.0.0-37

RUN apt-get update && apt-get --no-install-recommends -y install \
    build-essential && rm -rf /var/lib/apt/lists/* && useradd -u 1001 user

RUN npm install -g artillery@${ARTILLERY_VERSION}

WORKDIR /src

USER user

ENTRYPOINT [ "artillery" ]
