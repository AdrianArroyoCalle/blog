---
layout: post
title: Post Mortem: Torre Utopía
description: Análisis de Torre Utopía, lo que fue bien y lo que fue mal
keywords:
 - blogstack
 - ubuntu
 - linux
 - html5
 - gamedev
 - gamejs
 - postmortem
 - npm
 - marketplace
 - kongregate
 - typescript
 - fgl
 - clay.io
---

{% include software.html name="Torre Utopía" logo="images/TorreUtopia.png" url="http://adrianarroyocalle.github.io/torre-utopia" author="Adrián Arroyo Calle" version="1.0" os="html5" year="2014" %}

Torre Utopía fue un juego diseñado con el objetivo de ser creado en menos de un mes usando solo mis ratos libres. Para facilitar el trabajo había diseñado un conjunto de librerías y scripts en lo que denomino _esqueleto_. Este esqueleto es open-source y lo podeis encontrar en [GitHub](http://github.com/AdrianArroyoCalle/skeleton-npm-game).

# Desarrollo

![Elevator Action]({{ site.baseurl }}images/elevator-action.png)
Torre Utopía esta fuertemente inspirado en [Elevator Action](http://es.wikipedia.org/wiki/Elevator_Action). Inicialmente iba a ser un clon del juego pero según avanzó el desarrollo del juego vi partes que no eran fáciles de implementar y que requerirían un rediseño. Estoy hablando sobre todo del scrolling. Torre Utopía inicialmente fue pensado para ser programado en TypeScript que es como el esqueleto lo admite por defecto. Sin embargo terminé usando muy poco las características de TypeScript. Creo que porque no tengo soltura suficiente todavía en TypeScript como para usarlo correctamente. Aun así la inclusión fue positiva en cierto punto porque el compilador era capaz de avisarme de variables no definidas, un error que en JavaScript corriente es tedioso de solucionar pues debes mirar la consola del navegador.

Un acierto, creo yo, fue usar gráficos pre-generados para ir probando las mecánicas. Esto facilita mucho desde el principio saber como va a quedar cada cosa. Sin embargo, este arte pregenerado no fue sustituido al final enteramente dando una mala imagen al espectador. Realmente se cambiarón muchos gráficos pero la falta de tiempo hizo que tuviesen poco nivel de detalle. Una cosa que no me gustó fue que el personaje se moviera mirándote a ti. Y me cabrea más cuando pienso que hacerlo bien es muy sencillo de implementar.

La música era repetitiva y sin copyright pero quizá debería haber un botón para acabar con el dolor de oídos que genera escuchar una y otra vez lo mismo durante varias horas. Aunque el tema del audio lo implementé casi al final. Sin embargo no fue difícil alterar el resto del código para que al subir el ascensor sonase (aunque es posible que con algo de retardo).

La fuente usada quería que fuese estilo pixel para que encajase mejor; fue más difícil de lo que esperaba. Al final encontré una que encajaba con el estilo que quería dar y era gratuita.

![TorreUtopia]({{ site.baseurl }}images/TorreUtopia.png)

# Distribución

Una vez di por terminado el juego empezó la distribución. Estaba un poco impaciente porque era la primera vez que iba a publicar en tantos sitios a la vez. Sin embargo el tema de crearse cuentas en tantos sitios hizo que me decantase solo por 5 distribuidoras. Estas han sido:
 
 * [Kongregate](http://www.kongregate.com/games/aarroyoc/torre-utop-a)
 * [FGL](http://fgl.com)
 * MarketJS
 * [Clay.io](http://clay.io/game/torreutopia)
 * [Firefox Marketplace](https://marketplace.firefox.com/app/torre-utopía)

### Kongregate

![Kongregate]({{ site.baseurl }}images/Kongregate.jpg)

Simple y directo. Me publicaron el juego en poco tiempo y recibí comentarios de usuarios en el juego. Cuando miré por primera vez había generado 4 céntimos de euro. Lo más molesto de Kongregate es el tema fiscal. Ellos insisten en que lo cumplimentes todo aunque no es necesario. Esto es porque se pueden ahorrar impuestos (y tú ganar más) si lo cumplimentas. Para los que no lo conozcan en Kongregate ganas dinero por la publicidad que se ve en Kongregate cuando gente juega a tu juego. Es un portal de juegos pero con mucho tráfico.

### FGL

Originalmente diseñado para juegos Flash se ha adaptado y ofrece ahora también para HTML5 y Unity. FGL tiene muchas opciones de distribución y para un principiante puede ser confuso. Por suerte, FGL tiene ayudas en los márgenes muy útiles. En FGL ganamos dinero si nos compran el juego para publicarlo en portales de juegos. Todavía no he recibido ninguna oferta (tampoco espero, es mi primera vez) y se encargan de hacerte una valoración con nota en diferentes aspectos. En mi corta experiencia con FGL puedo decir que los administradores ayudan mucho (me enviaron correos varias veces para comunicarme fallos y como podría mejorar ciertas cosas)

### MarketJS

MarketJS es como FGL pero centrado exclusivamente en HTML5. Mal. Creí que por estar centrados en HTML5 (y obviamente más nuevos en el mundillo) tendrían algo más de simpatía. No sé si será la plataforma (mucho más verde en todos los aspectos) pero no recibí respuesta al publicar el juego. Semanas más tarde les envié un correo personalmente. Su respuesta fue que cambiase la imagen de la descripción. La cambié. Volví a publicar. Y ya está. Ninguna respuesta.

### Clay.io

Ya les conocía y el proceso es el habitual, algo mejor que de costumbre y todo. En Clay.io ganamos dinero por anuncios como Kongregate, pero también nos pueden comprar el juego como FGL y tiene un tercer modo que es dejar a los portales de juegos el juego tal cual y por los anuncios de Clay.io recibiremos dinero como si fuera en el propio sitio. Puse un anuncio de vídeo al principio y nada más. Y todavía no he ganado nada pero es más sospechoso si pensamos que Clay.io ha añadido mi juego a más portales con el tercer sistema como html5games.club

### Firefox Marketplace

![Firefox OS]({{ site.baseurl }}images/firefox-os.png)
Una tienda al estilo Google Play o App Store pero para Firefox OS. Fue aprobado y está disponible pero en esta versión no he añadido anuncios. Comentar que en Firefox Marketplace obtienes los certificados PEGI, ESRB y parecidos de manera gratuita, aunque solo valen para Firefox OS. Las certificaciones en principio te las dan según rellenas unas preguntas sobre el juego. Además hacen pruebas aleatorias cada institución y por ello pueden cambiarte la calificación. En mi caso ESRB me daba T y PEGI me daba +7. Pero en diferentes análisis (llegaron en diferentes meses) me dijeron que al estar los gráficos muy pixelados la violencia que contiene el juego es mínima, por ello actualmente tengo en ESRB la E y en PEGI +3.

# Recepción

Vamos a ver las críticas del juego a día de hoy:

* Firefox Marketplace: _Es como wrecking cree pero más chafa_ _4/5_ 
* FGL: _Definitely not my type of game, but could be fun. You need to think about touch controls (how will one play it on a mobile browser) and also improve graphics, like game over screen for example._
* FGL: _I like the concept for the game! Although the graphics needs some serious improvment but I think that the game could be fun with new graphics and some polish!_
* FGL, la review oficial: _
Intuitiveness:	5	Needs Improvement
Fun:	6	Average
Graphics:	5	Needs Improvement
Sound:	6	Average
Quality:	6	Average
Overall:	6	Average
Comments:
Instructions should be included in game. No-one will understand what's going on without them.Graphics are poor. They're programmer's art, not professional finished product. They're basic and very static(lack of animations). Need to be changed. Music is little low-quality. Also, there should be mute button on every screen. It's very frustrating for players if they can't mute music, especially if it's annoying. There should be always a way back to main menu(Home button or something like that). Policemans are staying in the same place as player and they can't shoot him if you don't move. There should be some text on main menu saying "Press anything to play"._
* Firefox Marketplace, un comentario oficial: _The game doesn't cover large screens._
* Kongregate: _Nice game, i recomend adding a menu, and make AI on the enemies._

# Conclusión

Hay que mejorar el esqueleto npm, el audio, los sprites (aunque seguiré usando gráficos pre-diseñados al principio). También creo que debe haber un menú, un sistema de anuncios integrados fácilmente desactivables via parámetros GET, integración con Google Analytics, ajustes para quitar el sonido, etc. Espero mejorar todos estos (y más aspectos que seguro que me olvido) para futuros juegos.
