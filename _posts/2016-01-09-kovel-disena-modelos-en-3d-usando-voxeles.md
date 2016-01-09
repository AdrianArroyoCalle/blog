---
layout: post
title: Kovel 1.0, diseña modelos en 3D usando vóxeles
description: Kovel es una aplicación para diseñar modelos tridimensionales usando vóxeles en Linux, Haiku y Windows.
keywords:
 - linux
 - ubuntu
 - blogstack
 - programacion
 - kovel
 - 3d
 - haiku
 - garficos
 - opengl
 - lanzamiento
 - windows
---

Hoy me he decidido y finalmente he decidido publicar la primera versión pública de [Kovel](http://adrianarroyocalle.github.io/kovel/). Estuve trabajando en esta aplicación a finales de 2015 y no he hecho muchos cambios últimamente por lo que voy a publicarlo antes de que ¡se me olvide!

## ¿Qué es Kovel?

Kovel es una aplicación para Linux, Haiku y Windows para diseñar modelos en 3D usando el concepto de los vóxeles. ¿Qué es un vóxel? Se ha definido un vóxel como un píxel con volumen, es decir, el equivalente a un píxel en entornos tridimensionales. Los vóxeles nunca existieron (los gráficos 3D no funcionan a través de vóxeles, son siempre vectoriales) y son simplemente un concepto artístico, muy sencillo de usar.

![Kovel]({{ site.baseurl }}images/Kovel-1.png)

![Kovel rotando]({{ site.baseurl }}images/KovelRotate.png)

## ¿Cómo funciona?

Es muy sencillo. Al crear un nuevo archivo seleccionaremos el tamaño de la rejilla. Por defecto la rejilla está puesta en 5. Esto quiere decir que el modelo tendrá una dimensión máxima de 5x5x5. Ahora seleccionamos el material. En esta versión solo hay colores puros como materiales, en futuras versiones habrá texturas también. Ahora simplemente hacemos click en los elementos de la rejilla. Vemos como se pone un vóxel en la posición que hemos indicado en la rejilla. Para subir y bajar de piso usamos los botones Up y Down. Podemos rotar y hacer zoom al modelos para centrarnos en determinadas áreas. En cualquier momento podemos deshacer. Los modelos se guardan como ficheros KVL. Es un formato que he tenido que inventar, es compacto y a la vez muy fácil de manipular. Está basado en BSON, la implementación binaria de JSON hecha por la gente de MongoDB. Pero además podemos exportar nuestras creaciones al formato Collada DAE (se puede abrir con Blender, Maya, etc).

![Blender]({{ site.baseurl }}images/BlenderKovel.png)

## ¿Dónde puedo obtenerlo?

Todo el código fuente está en [GitHub](http://github.com/AdrianArroyoCalle/kovel) y se compila usando [CMake]({{ site.fullurl }}{% post_url 2015-06-22-tutorial-de-cmake %}). Pero además hay disponible un PPA para usuarios de Ubuntu. Lamentablemente por temas de dependencias con CMake, solo está disponible en Wily (15.10) y Xenial (16.04), aunque si os descargais el DEB manualmente quizá os funcione también en Trusty (14.04) y Jessie (Debian 8). Los usuarios de Windows tienen un ejecutable también para 64 bits (no he compilado para 32 todavía) pero requiere las DLL de wxWidgets 3.0. Los usuarios de Haiku tendrán que conformarse de momento con el código fuente. Todas las descargas están en la página oficial de Kovel (incluidas las DLL).

<div style="text-align: center">
 <h5><a href="http://adrianarroyocalle.github.io/kovel/">Kovel</a></h5>
</div>

![Haiku y Kovel]({{ site.baseurl }}images/KovelHaiku.png)

## ¿Algo más?

Sí, aparte de Kovel, la aplicación gráfica, también existe `kovelcli`, la interfaz de línea de comandos. Permite realizar la conversión de KVL a Collada DAE de manera automática.

Finalmente, doy las gracias a todos los que vayan a probar Kovel, un simple comentario con sugerencias o de agradecimiento si os ha servido vale mucho para mí. ¡Felices vóxeles!
