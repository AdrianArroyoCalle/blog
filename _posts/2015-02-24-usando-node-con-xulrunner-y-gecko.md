---
layout: post
title: Usando Node con XULRunner y Gecko
description: node-webkit y NW.js han atraído la atención al público. ¿Por qué no una solución similar usando XUL Runner y Gecko?
keywords:
 - node.js
 - blogstack
 - linux
 - ubuntu
 - xulrunner
 - gecko
 - javascript
 - html5
---

Las aplicaciones basadas en [HTML5](https://es.wikipedia.org/wiki/HTML5) para el escritorio han ido en aumento. Soluciones como node-webkit, recientemente renombrado a [NW.js](http://nwjs.io/), han crecido en popularidad. Juegos como [Game Dev Tycoon](http://www.greenheartgames.com/app/game-dev-tycoon/) o aplicaciones como [Atraci](http://atraci.github.io/Atraci-website/) o [Popcorn Time](https://popcorntime.io/) son solo unos ejemplos de apliaciones que usan node-webkit. Sin embargo las personas que preferimos tecnología de Mozilla nos encontrabas con que no había nada que sirviese.

# [node-xulrunner](http://github.com/AdrianArroyoCalle/node-xulrunner)

Así que tenía que hacer algo. De momento es más que nada una prueba de concepto sin nada reseñable y con miles de bugs potenciales. Lo he diseñado para ser llamado desde una API de CommonJS. Esto permitirá tener un cliente de línea de comandos de manera sencilla, pero de momento no lo voy a hacer. Os enseñaré a usarlo con otro método

# Nuestra aplicación HTML5, Node.js, XULRunner

El primer paso será clonar el proyecto node-xulrunner de GitHub.

```sh
git clone http://github.com/AdrianArroyoCalle/node-xulrunner html5-app
cd html5-app
npm install
```

La estructura del proyecto ya es una aplicación empaquetable, de manera que solo tendremos que modificar ciertos ficheros. Necesitaremos editar el archivo _test.js_ para indicar ciertas preferencias sobre la aplicación. Algunos parámetros interesantes son _os_ que puede ser: win32, mac, linux-i686 o linux-x86_64 y _version_ que debe coincidir con una versión de XUL Runner disponible y publicada. El resto de opciones son autoexplicativas cuando las veais. En mi caso _test.js_ queda así:

```js
var xul=require("./index.js");

var options={
	os: "linux-i686",
	version: "35.0.1",
	name: "HTML5 App",
	vendor: "Adrián Arroyo",
	appVersion: "0.1.0",
	buildId: "00000001",
	id: "test@node-xulrunner",
	copyright: "2015 Adrián Arroyo Calle",
	width: 800,
	height: 800
};

xul.packageApp(options);
```

Ahora debemos crear nuestra aplicación propiamente dicha. Se encuentra bajo el directorio app/ y concretamente el fichero _main.js_ será el ejecutado nada más arrancar la aplicación. _main.js_ puede usar todas las APIs de Node. De hecho si usamos npm en esa carpeta funcionaría correctamente. En mi caso:

```js
var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello World\n');
}).listen(4200, '127.0.0.1');
console.log('Server running at http://127.0.0.1:4200/');
```
Y ahora los pasos mágicos. Vamos a la terminal y ejecutamos test.js con Node

```sh
node test.js
```
Nos saldrá una advertencia y empezará a descargar XULRunner y Node.js. Este ejecución no creará ninguna aplicación. Para, ahora sí, crear la aplicación debemos llamar otra vez a test.js

```sh
node test.js
```
Y en la carpeta build/ tendremos la aplicación lista para ser probada.Simplemente tendremos que ejecutar _app_

![HTML5 App con XULRunner]({{ site.baseurl }}images/HTML5App-XULRunner.png)
