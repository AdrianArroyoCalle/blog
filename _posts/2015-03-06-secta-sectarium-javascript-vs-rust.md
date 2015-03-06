---
layout: post
title: Secta Sectarium, JavaScript vs Rust
description: Durante el diseño de Secta Sectarium llegué a un punto de inflexión importante, JavaScript o Rust
keywords:
 - rust
 - javascript
 - typescript
 - node.js
 - gamedev
 - games
 - secta-sectarium
 - tycoon
---

![Fuente de Secta Sectarium]({{ site.baseurl }}images/SectaSectarium.svg)

Acabo de decidirme por el próximo proyecto grande que voy a realizar, se trata de Secta Sectarium, un juego estilo tycoon sobre controlar una secta. Voy a intentar reflejar en este blog todo lo que pueda sobre el desarrollo.

## Lenguaje de programación

Todavía no os voy a contar las mecánicas principales del juego así que vamos a ir directamente al tema técnico. Tenía serias dudas de cual usar. Me rondaban la cabeza C++, [Rust](http://rust-lang.org) y JavaScript.

#### C++

 * Pros
  * Alto rendimiento
  * Soporte multiplataforma (incluso para Haiku)
 * Contras
  * Tareas sencillas tienen que ser implementadas
  * Largos tiempos de compilación si usas librerías
  * Tampoco podía decidir si SDL o SFML
  
#### Rust
 * Pros
  * Alto rendimiento
  * Librerías fáciles de usar
  * Un lenguaje nuevo, con el que conviene acostumbrarse
 * Contras
  * Mal soporte en Windows
  * Poco soporte
  * Todavía no ha salido la versión 1.0

#### JavaScript
 * Pros
  * Soporte multiplataforma
  * Gran cantidad de librerías para todo
  * Lo conozco
 * Contras
  * Bajo rendimiento
  * Es fácil cometer errores simples

Al final me decanté por JavaScript (espero usar TypeScript de verdad) porque aunque el rendimiento puede ser peor, es un amigo (y enemigo a la vez, la historia es larga) conocido. Tiene un soporte para publicar juegos real (en contraposición a Rust) y es bastante rápido desarrollar.

Así que la elección de JavaScript es definitiva y de repente me surgen dos dudas
 * ¿Es mejor dibujar un mundo 2.5D en WebGL o en Canvas?
 * ¿Grunt o Gulp?

## WebGL o Canvas

Inicialmente pensaba hacerlo en Canvas, una API similar a la que esperaba usar en [SFML](http://sfml-dev.org) o [SDL](http://libsdl.org) con C++ o Rust. Fue cuando estaba viendo el issue tracker de un motor de 2.5D en JavaScript cuando comentaban que _sería mejor usar WebGL por rendimiento_. Y me surgió la duda. Sé que Canvas 2D es acelerado por hardware en Firefox pero ¿es algo en lo que se puede confiable? y aún siendo confiable ¿es peor el rendimiento de Canvas que WebGL?

Estuve investigando y resulta que WebGL es más rápido que Canvas en operaciones 2D _si lo usas bien_. Interesante concepto. En principio Secta Sectarium no va a ser muy exigente gráficamente así que acepto el desafío ya que soy algo familiar con OpenGL ES 2.0 y WebGL.

## Grunt o Gulp

Luego me surgió una duda relacionada con la construcción del proyecto. Había usado [Grunt](http://gruntjs.com) anteriormente pero el [esqueleto de juegos npm]({{ site.fullurl }}{% post_url 2014-10-26-esqueleto-de-juegos-npm %}) me quitaba las ganas de seguir usando Grunt. Era poco claro con tantas configuraciones. Sabía que existía Gulp, así que heché un vistazo y me han quedado buenas impresiones respecto a claridad. Así que uso [Gulp](http://gulpjs.com).

## Seguiré informando

Seguiré informando sobre Secta Sectarium y su desarrollo. Próximamente os enseñaré el proceso de documentación.
