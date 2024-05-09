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
