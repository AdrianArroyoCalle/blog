---
layout: post
title: Acortar enlaces en Node.js
description: Tutorial mostrando como acortar enlaces en Node.js usando Adf.ly, Bc.vc, Ouo.io, LinkShrink.net, Shorte.st y más.
keywords:
 - programacion
 - blogstack
 - linux
 - ubuntu
 - javascript
 - nodejs
 - dinero
 - ganar
 - enlaces
 - acortar
---

En alguna ocasión puede resultar necesario acortar enlaces desde nuestra aplicación en [Node.js](http://nodejs.org). Además, muchos acortadores añaden __anuncios intersticiales__ de los que podemos sacar un __dinero__. Algunos ejemplos de acortadores que comparten ganancias son:

* [Adf.ly](http://adf.ly/?id=4869054)
* [Bc.vc](http://bc.vc/?r=96749)
* [Ouo.io](http://ouo.io/ref/kZrfrYdn)
* [CoinURL.com](https://coinurl.com/index.php?ref=aarroyo)
* [Shink.in](http://shink.in/r/62630)
* [Shorte.st](https://shorte.st/es/ref/b4113e532f)
* [LinkShrink.net](http://linkshrink.net/ref=f6A6T)

Para facilitar el manejo de estos servicios y generar ingresos de manera sencilla he diseñado paquetes para todos esos servicios. Están disponibles en el registro de [npm](http://npmjs.com) y todos usan una API similar.

## Ejemplo práctico

Para el ejemplo voy a usar el paquete de Adf.ly, por ser quizá el proveedor de este tipo de enlaces más conocido.

Lo primero es instalar el paquete que provee acceso a Adf.ly:

```
npm install adf.ly --save
```

Ahora tenemos que cargar el módulo donde lo vayamos a usar. Aquí tenemos que escribir nuestra clave de API. Si lo dejais vacío seguirá funcionano, pero no ganareis nada, ¡los ingresos irán para mí!

{% highlight js %}
var adfly=require("adf.ly")("TU_CLAVE_DE_API");
o
var adfly=require("adf.ly")();
{% endhighlight %}

Para transformar un enlace en normal en uno acortado simplemente se usa el método `short`.

{% highlight js %}
adfly.short("http://nexcono.appspot.com",function(url){
	console.log("Enlace acortado: "+url);
    // Podemos usar la URL en algún motor de plantillas como Jade o EJS o donde queramos
});
{% endhighlight %}

![Paquete Adf.ly en Tonic]({{ site.baseurl }}images/adfly-npm.png)

En el paquete de Shink.in hay una particularidad. Shink.in permite acortar enlace en modo adulto. Esta opción está desactivada por defecto pero si quereis usarla solo hay que indicar `true` como tercer parámetro

{% highlight js %}
shinkin.short("http://nexcono.appspot.com",procesarURL,true);
// El enlace se acorta en Modo Adulto
{% endhighlight %}

## Listado de paquetes

El listado completo de paquetes que he creado es este. Todos tienen una API similar.

 * [adf.ly](https://www.npmjs.com/package/adf.ly)
 * [bc.vc](https://www.npmjs.com/package/bc.vc)
 * [cur.lv](https://www.npmjs.com/package/cur.lv)
 * [ouo.io](https://www.npmjs.com/package/ouo.io)
 * [linkshrink.net](https://www.npmjs.com/package/linkshrink.net)
 * [sh.st](https://www.npmjs.com/package/sh.st)
 * [shink.in](https://www.npmjs.com/package/shink.in)