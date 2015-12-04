---
layout: post
title: Mi primer debug. Primeros pasos con gdb, Valgrind y strace.
description: Guía de como realizar un debug, depurar, en C++ con gdb, Valgrind y strace para tratar de encontrar un error.
keywords:
 - programacion
 - linux
 - c++
 - cpp
 - gdb
 - valgrind
 - blogstack
 - ubuntu
 - debug
 - depurar
 - strace
---

¿A quién no le ha pasado? Estas programando en C\+\+ y de repente cuando antes todo iba bien, ahora el programa se cierra inesperadamente (un _crash_) y no sabes el motivo. En algunos lenguajes como [Rust](http://rust-lang.org), el propio compilador y el lenguaje evitan estas situaciones, pero en C\+\+ la situación es mucho más _estimulante_.

Recientemente, trabajando en [Kovel](http://adrianarroyocalle.github.io/kovel/) tuve uno de estos incidentes inesperados. Pero más inesperada fue su aparición, pues en [Debian](http://debian.org), donde programo actualmente, el programa se ejecutaba normalmente. Sin embargo en Windows el programa no llegaba a arrancar. Pensé que sería una diferencia Linux-Windows pero al probar en Fedora ocurrió lo mismo que en Windows, no llegaba a arrancar. Si encontraba el fallo en Fedora, que no se daba en Debian, resolvería también el fallo en Windows.

## Preparando la aplicación y el entorno

### Símbolos de depuración

Aunque no es obligatorio, es recomedable compilar los ejecutables que vayamos a someter a depuración con símbolos de depuración. En Windows se usan archivos independientes (ficheros PDB) mientras que en Linux se usan los mismos ejecutables con más metadatos en su interior. En GCC simplemente hay que añadir la opción __-g__ para retener los datos de depuración.

### Ficheros core

Ahora sería conveniente activar la generación de los ficheros __core__ en el sistema. En algunas distro ya está activado:

```
ulimit -c unlimited 
```

Los ficheros __core__ los usaremos si nuestra aplicación se paró en un punto de difícil acceso o que no podemos recrear nosotros mismos.

### Instalar gdb, Valgrind y los símbolos de las librerías

Ahora vamos a instalar el componente más importante, el debugger, la aplicación que usaremos para analizar la ejecución del programa.

![gdb]({{ site.baseurl }}images/gdb.png)

```
# En Fedora
sudo dnf install gdb
```

Además querremos tener los símbolos de depuración de las bibliotecas que use nuestro ejecutable. Con DNF, en Fedora, el proceso usa un comando específico:

```
sudo dnf debuginfo-install wxGTK SDL libstdc++ # Y las librerías que usemos
```

Y si queremos mantener los símbolos de depuración actualizados:

```
sudo dnf --enablerepo=updates-debuginfo update
```

Vamos a usar Valgrind también, aunque menos

```
sudo dnf install valgrind
```

## Cazando al vuelo

Supongamos que sabemos como generar el error. Llamamos a nuestro programa desde __gdb__:

```
gdb ./MiPrograma
```

Entraremos en gdb, con su propios comandos de herramientas. Lo primero que haremos será iniciar el programa, con el comando _run_ o _r_

```
(gdb) r
```

El programa se iniciará. Nosotros provocaremos el error. Una vez lo hayamos provocado podremos introducir más comandos. Vamos a ver que pasos se han seguido para producir el error.

```
(gdb) bt full
```

Y desde aquí podemos inspeccionar que funciones fueron llamadas justo antes de que el programa _petase_. En este punto también podemos buscar el valor de ciertas variables que nos interesen con _p nombrevariable_.

## Volviendo al pasado

No sabemos como se produjo el error, pero tenemos un fichero __core__ que nos va a permitir restablecer la situación del pasado para poder analizarla. Llamamos a gdb con el fichero core y nuestra aplicación.

```
gdb ./MiPrograma ./core
```

Una vez dentro podemos dirigirnos al punto crítico.

```
(gdb) where
```

Y analizamos como antes.

## Valgrind y fugas de memoria

Valgrind es muy usado para comprobar en que partes nuestro programa tiene fugas de memoria. En determinados casos puede ser más útil que gdb.

```
valgrind --leak-check=yes ./MiPrograma
```

Nuestro programa se ejecutará aproximadamente 20 o 30 veces más lento, pero se nos informará en todo momento de la gestión errónea de memoria que está produciéndose. En alguna situación será interesante saber de donde provienen estos fallos con mayor precisión, la opción _--track-origins=yes_ es nuestra amiga.

```
valgrind --leak-check=yes --track-origins=yes ./MiPrograma
```

Valgrind es muy estricto y puede generar falsos positivos. Hay varias GUI disponibles para Valgrind, una de ellas es [KCacheGrind](https://kcachegrind.github.io/html/Home.html).

![KCacheGrind]({{ site.baseurl }}images/KCacheGrind.gif)

Otra de ellas es [Valkyrie](http://www.open-works.net/projects/valkyrie.html)

![Valkyrie y Kovel]({{ site.baseurl }}images/Valkyrie.png)

## ¿Y si algún fichero no existe?

Para terminar vamos a suponer que nuestro programa falla porque hay un archivo que no logra encontrar y no puede abrirlo. Gracias a __strace__ es posible saber que archivos está abriendo el programa.

```
strace -eopen ./MiPrograma
```

Y nos saldrá en tiempo real los archivos que ha abierto nuestro programa.

![Strace y Kovel]({{ site.baseurl }}images/Strace.png)

Y espero que con este pequeño resumen ya sepais que hacer cuando vuestro programa  se cierra inesperadamente.