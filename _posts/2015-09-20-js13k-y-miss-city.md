---
layout: post
title: js13k y Miss City (postmortem)
description: Postmortem del juego MissCity, hecho en HTML5 y JavaScript para js13kgames.com
keywords:
 - javascript
 - html5
 - gulp
 - concurso
 - competicion
 - programacion
 - blogstack
 - gamedev
 - js13k
 - postmortem
---

Desde el 13 de agosto hasta el 13 de septiembre ha tenido lugar la competición [js13kGames](http://js13kgames.com) 2015. El objetivo es construir un juego en HTML5, en el plazo de un mes o menos que no ocupe más de __13kb__. EL fichero que no debe superar los 13kb debe ser un fichero ZIP con compresión estándar que tenga un fichero `index.html` desde el cual arrancará el juego y todo lo necesario para su funcionamiento estará también en el fichero ZIP. JavaScript, CSS, imágenes, sonido, fuentes, etc deberán estar en el fichero ZIP que no supere los 13kb. Está explicitamente prohibido cargar algún recurso del exterior como Google Web Fonts, CDNs de JavaScript, imágenes en otro servidor, etc. Además hay un tema para los juegos, que fue anunciado el 13 de agosto. El tema ha sido __Reversed__.

![js13k games logo]({{ site.baseurl }}images/js13k.png)

## MissCity

![MissCity]({{ site.baseurl }}images/MissCityGameplay.png)

El juego que he presentado se llama __MissCity__. El nombre viene de darle la vuelta a Sim de SimCity. Mis no existe, pero Miss sí, y es perdido. Así MissCity es _ciudad perdida_.

> _Euralia es la ciudad perfecta. Nuestra compañía desea construir un centro comercial en un solar abandonado pero el actual alcalde desea constuir una biblioteca. Dentro de poco son elecciones. ¡Debemos ganar las elecciones! Para ello puedes usar nuestro dron y repartir diversos tipos de ataques publicitarios a la población_

Los controles son:

* WASD para desplazarse (si estamos en móvil o tablet, se usa la inclinación del dispositivo)
* VBNM para los 4 diferentes tipos de ataque (si estamos en un dispositivo táctil, aparecen cuatro botones en pantalla que realizan el mismo efecto)

Ganamos:

* Si conseguimos suficientes votos entre el electorado

Perdemos:

* Si pasan dos minutos
* Si nos quedamos sin dinero (cada ataque publicitario cuesta una cantidad de dinero sin especificar)

![MissCity en Opera]({{ site.baseurl }}images/MissCityOpera.png)

Vamos a ver el postmortem en profundidad

## Cosas que fueron bien

### PathFinding

Los habitantes de Euralia son inteligentes, no van de una casilla a otra porque sí sino que tienen una ruta que realizar. El origen y el destino sí se calculan aleatoriamente, pero la ruta no, se usa un algoritmo de _pathfinding_. Debía encontrar una librería sencilla, pequeña, pero que implementase el algoritmo de manera limpia. Finalmente elegí [EasyStar.js](http://easystarjs.com) que es __asíncrona__, sin dependencias y entre sus características asegura que es __pequeña__ (~5kb) lo cual comprimido en ZIP resulta menos de lo que esperaba. Usa licencia MIT así que perfecto. El único inconveniente que presenta es que la rejilla que usa es bidimensional y yo definí la ciudad y el sistema de renderizado con un array unidimensional que voy cortando al procesarlo. Así que el juego tiene que transformar el array unidimensional en otro bidimensional para que EasyStar lo procese correctamente. Al obtener los resultados, es necesario volver a transformarlos.

### Recursos gráficos

Creía que mi juego iba a tener peores gráficos, sinceramente. Las imágenes en formato GIF ocupaban menos de lo que esperaba y pude incluir bastantes detalles. Al principio no usé imágenes, tiré de colores en CSS. Renderizar toda la ciudad fue muy sencillo. Esta no es la versión final por supuesto, pero no es muy diferente.

{% highlight js %}
// city es el array unidimensional donde defino el mapa de la ciudad

var draw=city.map(function(val){
    switch(val){
      case 0: return "rgba(91,196,124,1)";
      case 1: return "rgb(76, 77, 76)";
      case 2: return "rgb(84, 230, 54)";
      case 3: return "rgb(37, 88, 219)";
      case 4: return "rgb(223, 155, 23)";
    }
  });
  var x=0,y=0;
  draw.forEach(function(cell){
	ctx.fillStyle=cell;
	ctx.fillRect(x,y,box,box);
	x+=box;
	if((x+box)>id("a").width){
	  x=0;
	  y+=box;
	}
  });
{% endhighlight %}

### Debug en Firefox para Android

Me lo esperaba peor y realmente con WebIDE, el cable USB y ADB es muy sencillo ver la consola de JavaScript de Firefox para Android en tu ordenador.

## Problemas

![MissCity en Firefox]({{ site.baseurl }}images/MissCityFirefox.png)

## Dichosas APIs de pantalla y orientación

En HTML5 siempre me torturo con los aspect ratio y demás temas relacionados con la pantalla. En HTML5 hay tantas pantallas diferentes que simplemente no sé por donde empezar. El método que he usado en este juego es diferente al usado en otras ocasiones y daría para una entrada de blog suelta. Pero también me gustaría decir que las APIs de gestión de pantalla (saber si estás en modo _landscape_ o _portrait_) no funcionan entre navegadores todavía. Incluso tienen nombres incompatibles que surgen de distintas versiones del estándar. Es una cosa que las aplicaciones nativas de móviles saben hacer desde el día 1.

## EasyZIP

En MissCity he usado [Gulp](http://gulpjs.com) como herramienta que se encarga de la automatización de todo (ya sabes [¡haz scripts!]({% post_url 2015-08-04-haz-scripts %})). Usé __EasyZIP__ para generar el fichero ZIP y posteriormente comprobar que su tamaño seguía siendo inferior a los 13kb. Mi sorpresa vino cuando al subir el fichero ZIP provoqué un error en el servidor de js13kgames. Tuve que contactar con el administrador, hubo que borrar archivos que se habían extraído correctamente en el servidor aunque hubiese devuelto un error. La solución fue comprimirlo manualmente con __File Roller__ y el tamaño del fichero aumentó (sin pasar los 13kb).

## API de gestión de teclado

Firefox recomienda usar [KeyboardEvent.key](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/key) para leer el teclado y marca como obsoleta la manera antigua, que era [KeyboardEvent.keyCode](https://developer.mozilla.org/en-US/docs/Web/API/KeyboardEvent/keyCode). Leyendo MDN uno piensa que usando KeyboardEvent.key es la solución sin más. Y efectivamente en Firefox funciona bien, pero en Chrome y Opera no. Y pudiendo usar `keyCode`, quién va a usar `key`. `keyCode` será obsoleto pero funciona en todos los navegadores. Finalmente implementé el teclado usando `key` y `keyCode` si no soportan `key`.

## Juega

Si has leído hasta aquí, es un buen momento para jugar a MissCity. Hay un premio por compartir en redes sociales, si quieres ayudarme ya sabes.

<div style="text-align: center;">
<a href="http://js13kgames.com/entries/miss-city">MissCity</a>
</div>