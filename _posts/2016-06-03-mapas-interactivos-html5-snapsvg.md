---
layout: post
title: Mapas interactivos en HTML5 con SnapSVG
description: Introducción al procesado de archivos y visualizaciones SVG con la librería SnapSVG, de Adobe.
date: "2016-03-06 16:57:00"
keywords:
 - programacion
 - blogstack
 - html5
 - linux
 - ubuntu
 - javascript
 - svg
 - mapas
 - juegos
 - gamedev
---

HTML5 ha llegado aquí y está para quedarse y puede usarse en prácticamente cualquier sitio. Además según la [encuesta del blog]({{ site.fullurl }}{% post_url 2016-01-08-bienvenido-2016-bienvenido-kaizen %}) HTML5 era uno de los temas en los que estabais más interesados. Hoy vamos a ver como se puede hacer un mapa interactivo fácilmente, compatible con PCs, tabletas y móviles y veremos como los podemos animar.

<iframe width="100%" height="300" src="https://jsfiddle.net/aarroyoc/wyvjeoef/1/embedded/result,js,html/" allowfullscreen="allowfullscreen" frameborder="0"></iframe>

> _Haz click en la provincia de Valladolid múltiples veces_

## SnapSVG

Aquí entra en juego [SnapSVG](http://snapsvg.io). Se trata de una librería para JavaScript financiada y acogida por Adobe. Es una mejora de la ya popular librería para tratar SVG conocida como RaphaëlJS (ambas librerías son del mismo autor). Sin embargo, SnapSVG aporta muchas mejoras respecto a RaphaëlJS. La fundamental es que SnapSVG permite cargar archivos SVG ya existentes.

![SnapSVG]({{ site.baseurl }}images/snapsvg.png)

## Mapas en SVG

Actualmente es fácil encontrar mapas en SVG de cualquier territorio. Sin embargo para que sea fácil trabajar con ellos hay que procurar que estén preparados para interactuar con ellos. Es necesario que las etiquetas `<path>` posean un atributo `id` y sea fácilmente reconocible. En el caso del mapa de España que hay al principio, el mapa está muy bien organizado. Las provincias empiezan por pr, los enclaves por en y las islas por is. Así que Valladolid es `pr_valladolid` y Menorca es `is_menorca`. Encontrar mapas así ya puede ser más difícil pero no imposible.

## Primeros pasos

En nuestro HTML creamos una etiqueta `<svg>` con un `id`, por ejemplo `id=papel`. Ya está. Ahora pasamos al JavaScript.


Primero necesitamos obtener un papel (Paper en la documentación), con la función Snap y un selector CSS obtenemos el papel que ya hemos creado.

{% highlight js %}
var s = Snap("#papel");
{% endhighlight %}

Ahora ya podemos usar todo el poder de SnapSVG, pero si queremos trabajar con un SVG ya existente el procedimiento es un poco distinto.

{% highlight js %}
var s = Snap("#papel"); // Obtenemos el papel
Snap.load("/mapa.svg",function(f){
	// Al cargar el mapa se nos devuelve un fragmento
    // los fragmentos contienen elementos de SVG
    // Como queremos añadir todos los elementos, los seleccionamos todos, como un único grupo
    // otra vez vemos los selectores CSS en acción
    var g = f.selectAll("*");
    // y ahora añadimos el grupo al papel
    s.append(g);
    
    // cuando querramos acceder a un elemento podemos usar un selector CSS
    var valladolid = s.select("#pr_valladolid");
});
{% endhighlight %}

## Atributos

Podemos alterar los atributos de estilo de SVG. Para quién no los conozca, funcionan igual que las propiedades CSS pero se aplican de manera distinta. Con SnapSVG podemos cambiar esos atributos en tiempo de ejecución. Por ejemplo, el relleno (propiedad `fill`).

{% highlight js %}
s.attr({
	fill: "red"
});
// Cambia el relleno a rojo, afecta a los elementos inferiores, en este caso como es el papel, afecta a todo el SVG.
{% endhighlight %}

## Figuras simples

Podemos añadir figuras simples de manera muy sencilla

{% highlight js %}
var rect = s.rect(0,0,100,20).attr({fill: "cyan"});
// Creamos un rectángulo de 100x20 en la posición (0,0) con relleno cyan.
// Luego lo podemos borrar
rect.remove();
{% endhighlight %}

## Eventos y animaciones

Ahora viene la parte interesante, eventos y animaciones. SnapSVG soporta varios tipos de evento en cada elemento. Veamos el click simple aunque existe doble click, ratón por encima, táctil (aunque click funciona en pantallas táctiles).

{% highlight js %}
var murcia = s.select("#pr_murcia");
murcia.click(function(){
	murcia.attr({
    	fill: "yellow"
    });
});
{% endhighlight %}

Podemos animar los elementos especificando las propiedades que cambian y su tiempo

{% highlight js %}
murcia.animate({fill: "purple"},1000);
{% endhighlight %}

SnapSVG es muy potente y permite realizar muchas más operaciones, como elementos arrastrables, grupos, patrones, filtros y más. El objetivo, según Adobe, es ser el jQuery de los documentos SVG.

![Juego en SnapSVG]({{ site.baseurl }}images/snapsvg-game.png)

## Escalar imagen automáticamente

![SVG y viewBox]({{ site.baseurl }}images/viewBox.png)

SVG es un formato vectorial así que podemos aumentar el tamaño sin tener que preocuparnos por los píxeles. Sin embargo si simplemente cambias el tamaño del elemento `<svg>` vía CSS verás que no funciona. Es necesario especificar un atributo `viewBox` y mantenerlo constante. Básicamente viewBox da las dimensiones reales del lienzo donde se dibuja el SVG. Si cambian `width` y `height` y `viewBox` también entonces la imagen no se escala, simplemente se amplía el área del lienzo. Algunos mapas en SVG no ofrecen viewBox. En ese caso espeficicamos como viewBox el tamaño original del fichero SVG. En el caso de querer ocupar toda la pantalla.

{% highlight js %}
s.attr({ viewBox: "0 0 800 600",width: window.innerWidth, height: window.innerHeight});
window.addEventListener("resize",function(){
	s.attr({ viewBox: "0 0 800 600",width: window.innerWidth, height: window.innerHeight});
});
{% endhighlight %}

## Cordova y Android

SnapSVG se puede usar en [Apache Cordova](http://cordova.apache.org). Sin embargo yo he tenido problemas de rendimiento con la configuración por defecto en Android. Para solventar este problema he tenido que:

* [Instalar el plugin Crosswalk de Android WebView](https://crosswalk-project.org/documentation/cordova.html)
* Desactivar la aceleración por hardware en la aplicación.
  * En el AndroidManifest.xml poner `android:hardwareAccelerated="false"`

Solo así conseguí un rendimiento decente dentro de Cordova.