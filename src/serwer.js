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
