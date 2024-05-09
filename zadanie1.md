# Zadanie 1
## 1 Kod serwera

```
const express = require('express')
const app = express()
const port = 3000
var geoip = require('geoip-lite');
var http = require('http')


app.get('/',(req,res) =>{
    var ipAddress
    http.get({'host': 'api.ipify.org', 'port': 80, 'path': '/'}, function(resp) {
        resp.on('data', function(ip) {
            console.log("połączenie: " + ip);
            res.send("Twoje IP: "+ip+" <br> Aktualna data: "+
            new Date().toLocaleString({timeZone: geoip.lookup(String(ip)).timezone })
            )
          });
        });

   
})

app.listen(port,()=>{
    const date = new Date(Date.now()) 
    console.log("["+date.toLocaleString() +"] Autor: Dawid Skubij "+"  PORT: "+port)
})

```

## 2 Plik Dockerfile

```

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