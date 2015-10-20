---
layout: post
title: Usar GNU Parallel para aumentar el rendimiento de tus scripts
description: Tutorial con ejemplo de uso de GNU Parallel para aprovechar el procesador al 100% en tus scripts.
keywords:
 - blogstack
 - linux
 - ubuntu
 - script
 - bash
 - gnu
 - parallel
 - programacion
 - ffmpeg
 - optipng
---

La computación ha avanzado. Ha aumentado la potencia de cálculo. Y no lo ha hecho subiendo la velocidad del reloj del procesador, pues no queremos tener minitostadoras. En vez de eso se ha escogido el camino de _paralelizar_. Todo lo que sea susceptible de ser paralelizado deberá ser paralelizado. Desafortunadamente la programación en paralelo es compleja y requiere una planificación mucho más larga. ¡Pero no desistamos! ¡Podemos usar GNU Parallel para paralelizar algunas tareas que llevan tiempo pero son independientes las unas de las otras! __¡Usemos [GNU Parallel](http://www.gnu.org/software/parallel/) en nuestros scripts!__

![GNU Parallel]({{ site.baseurl }}images/Parallel.png)

Ejemplos prácticos:
 - Convertir una biblioteca de MP3 en OGG (con ffmpeg)
 - Normalizar el audio (con sox)
 - Optimizar las imágenes de un sitio web (con OptiPNG, jpegoptim, etc)

## Instalar GNU Parallel

En Debian/Ubuntu: 
```
sudo apt install parallel
```

En Fedora:
```
dnf install parallel
```

En openSUSE:

```
zypper install gnu_parallel
```


En Arch Linux:

```
pacman -S parallel
```


En NetBSD/SmartOS:

```
pkgin install parallel
```

## Convertir una biblioteca de MP3 en OGG y normalizar el audio

Esta era la tarea que tenía que realizar. Primero realicé una versión sencilla, que funcionaba utilizando un solo core del procesador.

{% highlight bash %}
#!/bin/bash
shopt -s globstar
for i in **/*.mp3; do
	BASENAME="${i%.mp3}"
	ffmpeg -i "${BASENAME}.mp3" "${BASENAME}.tmp.ogg"
	sox --show-progress --norm "${BASENAME}.tmp.ogg" "${BASENAME}.ogg"
	rm "${BASENAME}.tmp.ogg"
done
{% endhighlight %}

Con este script conseguimos el objetivo que nos habíamos propuesto, pero podemos optimizar el rendimiento. Usando GNU Parallel:

{% highlight bash %}
#!/bin/bash

# Guardar como "normalize.sh"

if [ "$2" = "1"  ]; then
	BASENAME="${1%.mp3}"
	ffmpeg -i "${BASENAME}.mp3" "${BASENAME}.tmp.ogg"
	sox --show-progress --norm "${BASENAME}.tmp.ogg" "${BASENAME}.ogg"
	rm "${BASENAME}.tmp.ogg"
else
	find  . -name "*.mp3" | parallel ./normalize.sh "{}" 1
fi
{% endhighlight %}

Con esta modificación GNU Parallel se encarga de poner en cola los trabajos de conversión y normalización y los reparte entre los cores disponibles del procesador. La gráfica explica claramente la diferencia de uso entre los dos scripts.

###### Versión básica

![Versión sin GNU Parallel]({{ site.baseurl }}images/TradicionalCore.png)


###### Versión GNU Parallel

![Versión con GNU Parallel]({{ site.baseurl }}images/GNUParallel.png)

## Optimizar las imágenes de un sitio web

Aquí viene otro ejemplo que usa GNU Parallel para realizar la tarea más rápidamente.

{% highlight bash %}
#!/bin/bash

# Guardar como "optimize-img.sh"

if [ "$2" = "1"  ]; then
	BASENAME="${1%.png}"
	optipng -o7 "${BASENAME}.png"
elif [ "$2" = "2"  ]; then
	BASENAME="${1%.jpg}"
	jpegoptim "${BASENAME}.jpg"
else
	find  . -name "*.png" | parallel ./optimize-img.sh "{}" 1
	find  . -name "*.jpg" | parallel ./optimize-img.sh "{}" 2
fi
{% endhighlight %}

Hay muchos más usos para GNU Parallel, solo tienes que usar tu imaginación. ¿Y tú? ¿Conocías GNU Parallel? ¿Qué opinas al respecto?
