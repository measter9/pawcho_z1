# syntax=docker/dockerfile:1
FROM scratch as builder
ADD alpine-minirootfs-3.19.1-aarch64.tar /

LABEL org.opencontainers.image.authors="Dawid Skubij"
# obraz podstawowy alpine i definicja autora

RUN addgroup -S node &&\ 
    adduser -S node -G node
# dodwanie nowego użytkownika

RUN apk update && \
    apk upgrade && \
    apk add --no-cache nodejs=20.12.1-r0 \
    npm=10.2.5-r0 && \
    rm -rf /etc/apk/cache
# instalacja i aktualizacja pakietów

USER node
WORKDIR /home/node/app
COPY --chown=node:node ./src/package.json ./package.json
RUN npm install
# przygotowanie i instalacja npm

COPY --chown=node:node ./src/serwer.js ./serwer.js
# kopiowanie pliku serwera

### etap 2

FROM node:iron-alpine
RUN apk add --no-cache curl

USER node
RUN mkdir -p /home/node/app
WORKDIR /home/node/app

# ustawienie katalogu

COPY --from=builder --chown=node:node /home/node/app/serwer.js ./server.js
COPY --from=builder --chown=node:node /home/node/app/node_modules ./node_modules

# kopiowanie gotowych plików z warstwy builder

EXPOSE 3000

HEALTHCHECK --interval=3s --timeout=30s --start-period=5s --retries=3 CMD curl -f localhost:3000 || exit 1

ENTRYPOINT [ "node","server.js" ]

# definicja portów, healthcheck i polecenie uruchomienia serwera