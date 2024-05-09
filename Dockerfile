# syntax=docker/dockerfile:1
FROM scratch as builder
ADD alpine-minirootfs-3.19.1-aarch64.tar /

LABEL org.opencontainers.image.authors="Dawid Skubij"


RUN addgroup -S node &&\ 
    adduser -S node -G node

RUN apk update && \
    apk upgrade && \
    apk add --no-cache nodejs=20.12.1-r0 \
    npm=10.2.5-r0 && \
    rm -rf /etc/apk/cache


USER node
WORKDIR /home/node/app
COPY --chown=node:node ./src/package.json ./package.json

RUN npm install
COPY --chown=node:node ./src/serwer.js ./serwer.js


###

FROM node:iron-alpine
RUN apk add --no-cache curl

USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY --from=builder --chown=node:node /home/node/app/serwer.js ./server.js
COPY --from=builder --chown=node:node /home/node/app/node_modules ./node_modules

EXPOSE 3000

HEALTHCHECK --interval=3s --timeout=30s --start-period=5s --retries=3 CMD curl -f localhost:3000 || exit 1

ENTRYPOINT [ "node","server.js" ]