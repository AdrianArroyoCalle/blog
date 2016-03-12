---
layout: post
title: Enebro, un robot automático para FOREX en JavaScript
description: Descripción de Enebro, un robot automático de bolsa
date: "2016-03-12 19:31:00"
keywords:
 - programacion
 - blogstack
 - linux
 - ubuntu
 - node.js
 - node
 - javascript
 - forex
 - enebro
---

Hoy en día el mundo de la bolsa y el trading está dominado por robots. Más del 70% de las transacciones que procesa Wall Street han sido generadas por algoritmos que funcionan ininterrumpidamente.

Probablemente tú también querrás usar robots. Hay soluciones para pequeños inversores como MetaTrader, pero voy a tratar de construir un bot de bolsa desde 0 en JavaScript. ¿Suena divertido?

![FOREX es divertido]({{ site.baseurl }}images/forex.jpg)

## PyAlgoTrading

El diseño de mi robot, Enebro, va a estar basado en [PyAlgoTrade](http://gbeced.github.io/pyalgotrade/). Los componentes principales de PyAlgoTrade son 6:

* Estrategias - Definen cuando comprar y cuando vender
* Entradas (o feeds) - Proveen datos. Pueden ser tantos datos financieros como datos provienientes de portales de noticias o Twitter.
* Brokers - Se encargan de ejecutar las órdenes
* DataSeries - Una abstracción usada para manejar los datos en su conjunto
* Indicadores técnicos - Realiza los cálculos de los indicadores técnicos usando datos de DataSeries.
* Optimizador - Cuando se realiza backtesting (probar la estrategia con datos pasados) este módulo permite realizarse en menos tiempo, distribuyendo el trabajo entre distintos ordenadores. Este módulo no lo voy a implementar en Enebro.

Vamos a trabajar ya en el programa, que operará el par EURUSD. El programa es meramente educativo y no está tan bien programado como debería pero servirá para entender algún concepto.

## Programando: Entradas o feeds

Lo primero que vamos a implementar son la entrada de los datos. Voy a implementar dos formas de obtener la información, una es leer los datos desd e un fichero CSV. Esto servirá para realizar backtesting. Además voy a añadir la entrada de datos de [Uphold](https://uphold.com), para obtener los datos en tiempo real

{% highlight js %}
"use strict";
var csv = require("csv");
var fs = require("fs");
var Bar = require("./strategy").Bar;

class Feed{
        constructor(instruments){
                this.instruments = instruments;
        }
}

class UpholdFeed extends Feed{
        constructor(instruments){
                super(instruments);
                this.Uphold = require("uphold-sdk-node")({
                        "key" : CLIENT_ID,
                        "secret" : CLIENT_SECRET,
                        "scope" : SCOPE,
                        "pat" : TOKEN
                });
        }
        run(cb){
                var self = this;
                setInterval(function(){
                        self.Uphold.tickers(function(err,tickers){
                			var date = new Date();
                			var isodate = date.toISOString();
                			var ask = tickers[12].ask;
                			var bid = tickers[12].bid;
                			var media = (ask+bid)/2;
                			console.log("EURUSD: "+ask+"-"+bid);
                            var bar = new Bar(media,media,media,media);
                            var bars = {};
                            bars[self.instruments] = bar;
                            cb(bars);
                        });
                },1000*60);
        }
}

class CSVFeed extends Feed{
        constructor(instruments,file){
                super(instruments);
                this.file = file;
        }
        run(cb){
                var reader = fs.createReadStream(this.file);
                var parser = csv.parse({
                        delimiter: ";"
                });
                var data = "";
                var self = this;
                parser.on("readable",function(){
                        while(data = parser.read()){
                                // Run onBars;
                                var bar = new Bar(data[1],data[4],data[2],data[3]);
                                var bars = {};
                                bars[self.instruments] = bar;
                                cb(bars);
                        }
                });
                reader.on("data",function(chunk){
                        parser.write(chunk);
                })
        }
}

module.exports = {CSVFeed: CSVFeed, UpholdFeed: UpholdFeed};
{% endhighlight %}

Veamos como funciona. Definimos una estrctura básica de Feed. Cada Feed hace referencia a un instrumento, en nuestro caso el instrumento es "EURUSD". Un feed necesita una función `run()` que será llamada una vez cuando tenga que funcionar el robot. A partir de ese momento el Feed asume la responsabilidad de proveer de datos al robot llamando siempre que haya nuevas barras (velas japonesas) a la función de callback `cb()`. En el caso de CSVFeed, la llamada a cb() se produce cada vez que se ha procesado una línea del fichero. En el caso de UpholdFeed, se envía una nueva barra cada minuto. En el caso de CSVFeed se pide un fichero en el constructor que se procesa con la librería __csv__ y en el caso de Uphold, se usa la API para obtener los precios. 

En esta primera parte hemos visto como usamos un objeto Bar que todavía no he enseñado, no es muy difícil.

{% highlight js %}
class Bar{
        constructor(open,close,high,low){
                this.open = open;
                this.close = close;
                this.high = high;
                this.low = low;
        }
        getPrice(){
                return this.close;
        }
}

{% endhighlight %}

## El bróker

Necesitamos un bróker, que se encargará de realizar las operaciones. Para realizar backtesting es necesario disponer de un bróker simulado, lo he llamando EnebroBroker. Soporta solo la operación de entrar en largo y salir de mercado.

{% highlight js %}
class EnebroBroker{
        constructor(capital){
                this.capital = capital;
                this.register = {};
                this.benefit = 0;
        }
        enterLong(instrument,price){
                if(!this.register[instrument])
                        this.register[instrument] = [];
                this.register[instrument].push({
                        shares: Math.floor(this.capital/price),
                        price: price
                });
                this.strategy.open = true;
                this.strategy.onEnterOK();
        }
         exitMarket(instrument,price){
                var last = this.register[instrument].pop();
                var diff = price - last.price;
                var total = diff * last.shares;
                this.benefit += total;
                this.strategy.open = false;
                this.strategy.onExitOK();
                console.log("Operation Closed: "+total);
                console.log("Benefit: "+this.benefit);
        }
}
{% endhighlight %}

Básicamente, se le añade un capital al iniciarse y usa TODO el capital en realizar la operación. La estrategia si queremos diversificar con Enebro es tener muchos brokers con una estrategia asignada a cada uno. Para realizar la compra especificamos el instrumento y el precio actual, para salir igual. Se nor informará en la pantalla del beneficio por la operación y del beneficio acumulado.

## La estrategia

Veamos una estrategia sencilla usando la media móvil simple de 15.

{% highlight js %}
class Strategy{
        constructor(feed,instrument,broker){
                this.setup();
                this.sma = new SMA(15);
                this.feed = feed;
                this.instrument = instrument;
                this.broker = broker;
                this.open = false;
                this.broker.strategy = this;
        }
        onBars(bars){
        
        }
        run(){
                var self = this;
                this.feed.run(function(bars){
                        self.onBars(bars);
                });
        }
        isOpen(){
                return this.open;
        }
}
class MMS extends Strategy{
        constructor(feed,instrument,broker){
                super(feed,instrument,broker);
        }
        onBars(bars){
                var bar = bars[this.instrument];
                this.sma.add(this.instrument,bar);
                if(!this.isOpen()){
                        // Buy
                        if(bar.getPrice() < this.sma.get(this.instrument)){
                                this.broker.enterLong(this.instrument,bar.getPr$
                        }
                }else{
                        // Sell
                        if(bar.getPrice() > this.sma.get(this.instrument)){
                                this.broker.exitMarket(this.instrument,bar.getP$
                        }
                }
        }
}

{% endhighlight %}

Esta estrategia está basada en la media móvil simple, únicamente en eso. El feed provee de datos a la estrategia en la función `onBars`. Se actualiza el único indicador, la media móvil simple, __SMA__. Cuando se cumple la condición de compra y no hay operaciones abiertas, se entra en largos. Cuando hay operaciones abiertas y hay condición de venta, se vende. Cuando creamos la estrategia y la ejecutamos con `run()` tenemos que especificar el feed, el instrumento y el bróker.

## Los indicadores: SMA

Hemos usado el indicador de la media móvil simple. ¿Cómo lo hemos definido?

{% highlight js %}
class SMA{
        constructor(period){
                this.period = period;
                this.sma = {};
        }
        add(instrument,bar){
                if(!this.sma[instrument])
                        this.sma[instrument] = [];
                this.sma[instrument].push(bar);
        }
        get(instrument){
                if(this.sma[instrument].length < this.period +1)
                        return 0;
                var suma = 0;
                for(var i=this.sma[instrument].length - this.period;i<this.sma[$
                        suma += parseFloat(this.sma[instrument][i].getPrice());
                                        }
                return suma/this.period;
        }
}
{% endhighlight %}

Simplemente almacena los datos y los usa para realizar la media cuando sea necesario.

## Juntándolo todo

Ahora juntamos todo en el archivo `index.js`

{% highlight js %}
var CSVFeed = require("./feed").CSVFeed;
var UpholdFeed = require("./feed").UpholdFeed;
var MMS = require("./strategy").MMS;
var EnebroBroker = require("./strategy").EnebroBroker;
var UpholdBroker = require("./strategy").UpholdBroker;

var feed = new CSVFeed("EURUSD","DAT_ASCII_EURUSD_M1_201602.csv");
//var feed = new UpholdFeed("EURUSD");

//var broker = new UpholdBroker(8.69);
var broker = new EnebroBroker(100);

var strategy = new MMS(feed,"EURUSD",broker);
strategy.run();

{% endhighlight %}

## Conclusión

Espero que esta entrada al menos os sirva de inspiración para diseñar vuestro propio sistema de trading automático. Enebro es un simple experimento, pero si quereis aportar información, sugerir algo o preguntar, simplemente escribid en los comentarios.

Yo tengo mi propia versión de Enebro operativa, si alguien la quisiera, puede contactar conmigo. Además el plugin de bróker de Uphold, necesario para realizar las operaciones reales de FOREX también está disponible para quien lo quiera.