---
layout: post
title: eurocookie-js
description: Introducción al módulo de JavaScript (NPM y Bower) para gestionar la ley de cookies en la unión europea.
keywords:
 - programacion
 - blogstack
 - npm
 - javascript
 - cookies
 - europa
 - bower
 - linux
 - ubuntu
---

Hace ya algún tiempo que la ley europea en materia de privacidad se ha venido aplicando en [España](https://www.cia.gov/library/publications/the-world-factbook/geos/sp.html). La ley define que no se pueden almacenar datos que identifiquen al usuario con fines estadísticos (o publicitarios) a menos que se pida un consentimiento al usuario y este lo acepte. Solo lo deben cumplir aquellas personas que tengan un beneficio económico con la web. En empresas hay que aplicarlo siempre. El almacenamiento más usado para este tipo de identifición han sido las cookies, de ahí el nombre popular de __"ley de cookies"__.

![Bandera de la Unión Europe en la Torre Eiffel]({{ site.baseurl }}images/UnionEuropea.jpg)

## Odisea entre las cookies

Yo uso cookies. Las uso en este blog y en otros sitios. [Google Analytics](https://www.google.com/analytics) requiere consentimiento, [Disqus](https://disqus.com/) requiere consentimiento, [Google AdSense](https://www.google.com/adsense) requiere consentimiento. __Los widgets sociales__ de Twitter, Facebook, Google+, etc requieren consentimiento.

> _¿Pero entonces todas las cookies necesitan consentimiento?_

No. Sólo las que identifican al usuario con fines estadísticos, que en el caso de los gigantes de Internet es siempre. Si usamos nuestras propias cookies y no las conservamos para posterior análisis no haría falta y no hay que pedir consentimiento.

![Cookies vintage]({{ site.baseurl }}images/Cookies.jpg)

> _Cookies son las más usadas, pero si usas WebStorage (localStorage) o almacenamiento de Flash también tendrás que cumplir_

## eurocookie-js al rescate

Basado en un pequeño plugin hecho por Google bajo licencia Apache 2.0. Se trata de un pequeño fichero JavaScript que al cargarse pedirá el consentimiento (si no ha sido preguntado antes). Este consentimiento es __molesto__, forzando al usuario a aceptar si quiere leer cómodamente la web. Una vez acepta el consentimiento se carga todo el JavaScript que necesitaba consentimiento. Esto último es algo que __muchos plugins de consentimiento de cookies no hacen__. Realmente no sé si simplemente avisando se cumple la ley, bajo mi interpretación __no__. Y por eso este plugin. Además eurocookie-js está traducido a una gran cantidad de idiomas de la Unión Europea (tomadas directamente de las traducciones oficiales de Google para webmasters sobre esta ley). Vamos a ver como se usa.

## Instalando eurocookie-js

Instalar eurocookie-js es más simple que el mecanismo de un botijo. Hay 3 maneras:

* npm - `npm install eurocookie-js --save`, pensado para usarlo con browserify
* bower - `bower install eurocookie-js --save`
* directamente - descarga el archivo `index.js` de GitHub: [http://github.com/AdrianArroyoCalle/eurocookie-js](http://github.com/AdrianArroyoCalle/eurocookie-js)

![Biscuits, galletas]({{ site.baseurl }}images/Biscuit.jpg)

## Usando eurocookie-js

### Identificar JavaScript que necesita consentimiento

Primero, necesitamos identificar que JavaScript necesita consentimiento. Si usa una etiqueta `script` es fácil. Es importante declarar el tipo MIME del script como texto plano y le añadimos la clase cookie.

{% highlight html %}
<script type="text/plain" class="cookie">
 // USEMOS COOKIES FELIZMENTE, ENVIEMOS DATOS A LA NSA
</script>
{% endhighlight %}

En muchos casos bastará, por ejemplo con Disqus o con Google Analytics, puesto que cargan asíncronamente los archivos. En otros casos donde usemos el atributo `src` de `script` tendremos que modificar el código que se nos provee por el siguiente.
{% highlight html %}

<script src="http://servidor.com/archivo.js"></script>

<!-- Será sustituido por -->

<script type="text/plain" class="cookie">
var file = document.createElement('script');
file.type = 'text/javascript';
file.async = true;
file.src = "http://servidor.com/archivo.js";
document.getElementsByTagName('head')[0].appendChild(file);
</script>
        
{% endhighlight %}

Aunque si el proveedor te requería usar `script src` posiblemente no soporte la carga asíncrona.

### Activando eurocookie-js

Ahora solo nos falta activar eurocookie-js. Es fácil. Al final, antes de cerrar `body` tenemos que añadir lo siguiente:

##### Si usamos Bower o el método manual

{% highlight html %}
<script>
euroCookie("http://enlace-a-politica-de-privacidad.com");
</script>
{% endhighlight %}

##### Si usamos npm + browserify

{% highlight html %}
var ec=require("eurocookie-js");
ec.euroCookie("http://link-to-privacy-policy.com");
{% endhighlight %}

El fichero generado por browserify podrá ser añadido directamente al HTML.

## Más información

Como siempre, toda la información está en GitHub: [http://github.com/AdrianArroyoCalle/eurocookie-js](http://github.com/AdrianArroyoCalle/eurocookie-js)