# Zadanie 1

- [1. Kod serwera](#1-kod-serwera)
- [2. Kod dockerfile](#2-plik-dockerfile)
- [3. Uruchamienie](#3-uruchamianie-obrazu)
- [CVSs](#docker-scout)


## 1 Kod serwera

```
const express = require('express')
const app = express()
const port = 3000
var geoip = require('geoip-lite');
var http = require('http')


app.get('/',(req,res) =>{
    //obsługa strony domyślnej wyświetla adres it klienta i godzine w jego strefie czasowej
    //ip jest pobierane z zewnętrzengo api aby zawsze uzyskać zewnętrzne ip na localhost
    http.get({'host': 'api.ipify.org', 'port': 80, 'path': '/'}, function(resp) {
        resp.on('data', function(ip) {
            console.log("połączenie: " + ip);
            res.send("Twoje IP: "+ip+" <br> Aktualna data: "+
            new Date().toLocaleString({timeZone: geoip.lookup(String(ip)).timezone })
            )
          });
        });

   
})
    //logowanie włączenia serwera
app.listen(port,()=>{
    const date = new Date(Date.now()) 
    console.log("["+date.toLocaleString() +"] Autor: Dawid Skubij "+"  PORT: "+port)
})

```

## 2 Plik Dockerfile

```
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
```

## 3 Uruchamianie obrazu

Budowanie:

`docker buildx build --sbom=true --provenance=true --tag zadanie1 .`

Uruchamianie:

`docker run -p 3000:3000 -d --rm --name zad1test zadanie1`

Sprawdzanie logów kontenera

`docker logs zad1test`

![logi](/imgs/image.png)

Sprawdzanie ilości warstw

`docker history zadanie1`

![history](/imgs/image1.png)

![dzialanie](/imgs/image2.png)

## Docker Scout

Sprawdzenie oceny cvss

`docker scout cves --format only-packages --only-vuln-packages zadanie1`

![cves](/imgs/image3.png)