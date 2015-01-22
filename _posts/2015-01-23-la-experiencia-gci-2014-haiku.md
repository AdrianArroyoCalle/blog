- - -
layout: post
title: La experiencia GCI 2014 con Haiku
description: Resumen de mi experiencia en el GCI 2014 con Haiku, la organización que elegí
keywords:
 - haiku
 - gci
 - 2015
 - opensource
 - beapi
 - freecell
 - todo
 - haikuports
 - libuv
 - node.js
 - openscenegraph
 - superfreecell
 - haikutodo
 - blogstack
 - linux
- - -

El día 1 de diciembre comenzaba el [Google Code-In 2014](http://www.google-melange.com/gci/homepage/google/gci2014) y hasta el 19 de enero pude trabajar en la organización que había elegido, en este caso Haiku, como el año anterior. 


# HaikuToDo

![HaikuToDo 1]({{site.baseurl}}images/HaikuToDo-1.png)
La tarea consistía en reusar cierto código de una aplicación de tareas para crear un frontend en Haiku usando la BeAPI. Sin embargo ese código no funcionaba. No tenía sistema de compilación y más tarde descubrí que carecía de punto de entrada y ciertas headers no coincidían con la implementación. Así que lo hice de 0. En primera instancia usé SQlite para almacenar las tareas. Sin embargo me pidieron que mejorara mucho más la interfaz. Eso hice y en el camino tuvo que inventarme el sistema de categorías. La siguiente tarea consistía en reemplazar [SQlite](http://sqlite.org) por algo específico de Haiku y BeOS. Hablo de BeFS y su sistema de Queries. Gracias a C++ solo tuve que crear un objeto que implementase las operaciones de escritura con BeFS y pude mantener el de SQlite (hay que activarlo en tiempo de compilación). La siguiente tarea consistía en añadirle el soporte online. Valía cualquiera pero elegí Google Tasks porque ya tenía cuenta. Toda la gestión de HTTP se debía realizar por las APIs nativas de Haiku. Estas son APIs que BeOS no llegó a incorporar nunca. Además el procesado de JSON corría a cargo de las APIs de Haiku que al igual que las de HTTP están indocumentadas. Obtener la información de Google puede parecer lioso pero una vez lo entiendes es bastante sencillo. Para la autenticación, HaikuToDo abre WebPositive para que te registres con Google y recibes un código. Ese código lo pones en la aplicación y se descargarán tus tareas de Google. El soporte actual es de solo lectura. [La aplicación tiene licencia MIT y se puede descargar](http://github.com/AdrianArroyoCalle/HaikuToDo)
![HaikuToDo 1]({{site.baseurl}}images/HaikuToDo-2.png)

# SuperFreeCell

![HaikuToDo 1]({{site.baseurl}}images/SuperFreeCell-1.png)
¿Quién no ha jugado al solitario de Windows? ¿Y al Carta Blanca también conocido como [FreeCell](https://es.wikipedia.org/wiki/FreeCell)? Seguro que alguno más pero también muchos. La tarea consistía en hacer el clon de FreeCell para Haiku. Por supuesto usando la BeAPI, en concreto la gran flexibilidad de [BView](http://api.haiku-os.org/classBView.html) para estas tareas. Para ello tomé como referencia BeSpider, el clon del solitario spider en Haiku. Luego comprendí que no entendía mucho el código y lo empecé a hacer a mi manera. Se me ocurrió hacer las cartas un objeto que se tenía que dibujar. Error. La interación con el resto del mundo se hecha en falta. Luego pensé en que heredasen BView. Error. El número de glitches gráficos era digno de mencionar. Finalmente las cartas pasaron a ser estructuras simplemente e hice toda la lógica en la BView del tablero. El resultado era mucho mejor. Cambié el algoritmo de ordenación de cartas (barajar, si alguien no se enterá) para ganar en velocidad. Antes usé uno con bucles muy simple pero lentísimo. Otros detalles fue que use DragMessage para mover las cartas y que las cartas son PNGs de BeSpider integrados dentro del ejecutable (una cosa que siempre he hechado en falta a Linux). Obviamente al hacer un clon tuve que jugar mucho a otras implementaciones de FreeCell. Jugué a la de Windows 7, [Ubuntu 14.04](https://wiki.gnome.org/action/show/Apps/Aisleriot?action=show&redirect=Aisleriot) y [Android](https://play.google.com/store/apps/details?id=com.mobilityware.freecell). Todo sea por SuperFreeCell. [La aplicación tiene licencia MIT y se puede descargar](http://github.com/AdrianArroyoCalle/SuperFreeCell)
![HaikuToDo 1]({{site.baseurl}}images/SuperFreeCell-2.png)

# Haiku EGL
[EGL](http://es.wikipedia.org/wiki/EGL) es una API del [Khronos Group](http://khronos.org) para definir _superficies_ sobre las que operar con otras APIs de Khronos Group, entre ellas OpenGL y OpenVG. EGL se ha usado sobre todo en móviles pero el salto a escritorio es inminente (Wayland y Mir dependen de EGL para funcionar). La API es teóricamente multiplataforma aunque en la práctica hay que modificar el código si usamos las X11 o Wayland o en este caso Haiku. La tarea consiste en portar EGL de manera que funcione en Haiku como wrapper de BGLView. La tarea requería modificar código de Mesa 10. Tuve muchos problemas en esta tarea: documentación nula, características exclusivas de C99 (y que no están en C++), desconocimiento de parte del sistema gráfico tanto en Linux como en Haiku, desconocimiento de SCons, etc. Esto me llevó a implementar EGL en un principio como un driver DRM2. Pero luego descubrí que DRM2 solo funciona en Linux. Así que tuve que escribir un driver desde 0. Este crea una configuración placebo y realiza operaciones básicas como crear una ventana y hacer el intercambio de búferes.
# Haikuports

El resto de tareas consistían en portar software normal y corriente a Haiku. He portado con más o menos dificultad:
 - [OpenSceneGraph](http://openscenegraph.org)
 - [EntropiaEngine++](http://bitbucket.org/SpartanJ/eepp)
 - [libuv](http://github.com/libuv/libuv)

Quería haber portado Node.js pero dependía de libuv que no estaba portado. Después comprobé que nuestra versión del motor V8 estaba desactualizada para Node.js así que no tuve tiempo para terminarla.
