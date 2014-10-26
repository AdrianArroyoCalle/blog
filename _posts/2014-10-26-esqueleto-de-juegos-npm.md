---
layout: post
title: Esqueleto de juegos NPM
description: Creando un esqueleto para juegos basados en JavaScript
keywords:
 - blogstack
 - npm
 - nodejs
 - javascript
 - gamedev
 - grunt
---
Quería haber empezado este mes con el desafío [One Game a Month] pero mis herramientas no estaban listas tal y como recomendaba el libro [The Game Jam Survival Guide] de [Christer Kaitila]. Así que este mes lo dediqué a hacer herramientas para las juegos. Concretamente he desarrollado dos sets de herramientas (esqueletos a partir de ahora). Uno es de [JavaScript]/[TypeScript] y el otro de C++. Quería haber hecho uno de Rust, pero hasta que no salga la 1.0 y lo pueda probar en Windows en condiciones no habrá esqueleto de Rust. Así pues hecha la introducción, en este post voy a hablar del esqueleto de [JavaScript]/[TypeScript] que es el que hice primero.

## Descripción del esqueleto

El esqueleto ha sido diseñado alrededor de [Grunt] para su fácil manejo. Me encanta ver como Grunt puede con todo lo que le echen y más (lo único que le falta es un plugin nativo de C++ al estilo de Gradle). Actualmente el esqueleto usa [TypeScript] para el código. Este maneja las definiciones con [TSD], se compila y finalmente se le  pasa por [Browserify] para convertirlo en un único fichero. A parte no hay ficheros [HTML], sino que son plantillas [Jade]; la razón no es muy clara pero prefería tener Jade antes que HTML básico. Quizá me sentía inspirado y pensé que le daba un toque más _[node.js]_. Y el CSS tampoco se usa directamente, sino que debemos pasar por el compilador de [LESS] (aquí la ventaja es más clara que con Jade/HTML). Adicionalmente podemos generar documentación si estuviese documentado el código con [TypeDoc] y generamos una página del manual de UNIX con markedman. Posteriormente en etapas finales del juego podemos generar iconos de todos los tamaños imaginables (Apple iOS iPhone sin retina, con retina, iPad, iPad mini,... incluso para el navegador Coast). Además se minifican las imágenes con [OptiPNG] y sus equivalentes para JPG y GIF. Para acabar se añade una tag al repositorio Git y se publica en el repositorio, pero en el branch gh-pages. También he diseñado otra ruta para el empaquetamiento en local de la aplicación. Usando [NodeWebkit] y un plugin para hacer un paquete [Debian] (tengo pendiente el RPM) y comprimiendo el resultado en un ZIP listo para el [Firefox Marketplace]. Además, sin estar automatizados hay código para [Ubuntu Touch], [Android] y [Chrome OS].

## ¿Cómo se usa?

Buena pregunta. Primero debemos clonar el repositorio Git y tenemos que tener en cuenta que a partir de ahora podemos modificar todo con fin de que se adapte a nuestras necesidades. Entonces clonamos con:

```
git clone https://github.com/AdrianArroyoCalle/skeleton-npm-game TU_JUEGO
```

Ahora debemos instalar las dependencias. Te recomiendo que vayas a por un café o algo ya que el sistema de dependencias empotradas de [NPM] hace que el tamaño de la descarga se nos vaya de las manos con ciertas dependencias duplicadas y reduplicadas. Así que entra en la carpeta creada llamada TU_JUEGO y pon:

```
npm install
```

Adicionalmente si no tienes [Grunt] instalado, instálalo con:

```
npm -g grunt-cli
```

Es posible que según tu configuración lo debas ejecutar como root o no.
Una vez descargado solo nos quedaría empezar el desarrollo. Podemos hacer una pequeña prueba de que todo se haya instalado con:

```
grunt test
```

## Librerías incluidas

He incluido las siguientes librarías y me gustaría añadir unas cuantas más pronto:

* BABYLON.JS
* three.js
* GameJS
* Box2d.js
* Cannon
* meSpeak
* Bongo.js
* Hammer.js
* Canvace
* i18next

Y sin duda me gustaría añadir alguna más, pero con estas creo que se pueden dar muchas combinaciones.

## Y una cosa más...

He intentado recopilar la mayor cantidad de sitios donde publicar los juego una vez terminados. La lista ya es bastante grande pero no están probados todas las empresas allí expuestas. Además hay que tener ciudado ya que hay tiendas que son incompatibles entre ellas.

[JavaScript]: https://developer.mozilla.org/es/docs/Glossary/JavaScript
[Grunt]: http://gruntjs.com
[NPM]: http://npmjs.org
[Ubuntu Touch]: http://ubuntu.com
[Android]: http://android.com
[Firefox Marketplace]: http://marketplace.firefox.com
[TypeScript]: http://www.typescriptlang.org/
[LESS]: http://lesscss.org/
[Jade]: http://jade-lang.com/
[HTML]: http://www.w3.org/
[TSD]: https://www.npmjs.org/package/tsd
[Browserify]: http://browserify.org/
[OptiPNG]: http://optipng.sourceforge.net/
[TypeDoc]: http://typedoc.io/
[NodeWebkit]: https://github.com/rogerwang/node-webkit
[node.js]: http://nodejs.org
[One Game a Month]: http://www.onegameamonth.com
[The Game Jam Survival Guide]: http://www.mcfunkypants.com/jam
[Christer Kaitila]: http://www.mcfunkypants.com
[Chrome OS]: https://developers.google.com/chrome/apps/docs/
[Debian]: http://debian.org
