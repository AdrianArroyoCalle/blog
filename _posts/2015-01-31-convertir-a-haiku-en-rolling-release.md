---
title: Convertir a Haiku en rolling release
layout: post
description: Las distros como Arch Linux han hecho famoso este concepto que ya llega a Haiku
keywords:
 - haiku
 - rolling-release
 - pkgman
 - blogstack
 - linux
 - ubuntu
---

Las distros como [Arch Linux](http://archlinux.org) han hecho famoso el concepto de _rolling release_. ¿No sabes lo qué es? Consiste en el software que está en constante actualización y elimina el concepto de versión, al menos como se pensaba de él. Por ejemplo en [Ubuntu](http://ubuntu.com) que no es rolling release el sistema se actualiza pero llegará un momento que para dar un cambio mayor deberemos cambiar a otra versión (de 12.04 a 14.04 por ejemplo). Arch Linux es rolling release y no tiene versiones, siempre que actualizas estás en la última versión.

# Rolling release en Haiku ¿era algo esperado?

Seguramente la gente que conoce Haiku no piense que sea un sistema que aspirase a ser rolling release. Yo tampoco y de hecho no es rolling release oficialmente, sigue teniendo versiones y nightlies pero ahora y gracias al nuevo sistema de paquetería ha sido posible convertir Haiku en rolling release

# Los pasos

Los pasos a seguir son sencillos pero deben hacerse por línea de comandos. Así que abre la aplicación Terminal y escribe:

```sh
pkgman list-repos
```

Esto mostrará los repositorios que haya en el sistema. Tendrás que tener 1 por lo menos llamado HaikuPorts. Lo vamos a eliminar, pues está fijado a una versión y entraría en conflicto con los repositorios de rolling release.

```sh
pkgman drop-repo HaikuPorts
```

Y ahora añadimos el repositorio HaikuPorts de rolling release

```sh
pkgman add-repo http://packages.haiku-os.org/haikuports/master/repo/x86_gcc2/current
```

Ahora ya tendremos las últimas aplicaciones, sin embargo el sistema más básico (el kernel y el navegador) no se actualizarán. Debemos de añadir otro repositorio

```sh
pkgman add-repo http://packages.haiku-os.org/haiku/master/x86_gcc2/current
```

Y ya está. Ahora podemos actualizar el sistema entero (requiere reinicio para usar el nuevo kernel).

![Actualizando Haiku]({{ site.baseurl }}images/Updating.png)

```sh
pkgman update
```

# Otros repositorios

Todavía no ha salido la Beta 1 y ya hay repositorios externos para pkgman. Se añaden de igual manera que los anteriores.

 * Guest One's bin ports: http://haiku.uwolke.ru/repo/binaries-x86_gcc2
 * Guest One's Java ports: http://haiku.uwolke.ru/repo/java-ports
 
![Mis repositorios]({{ site.baseurl }}images/ListRepos.png)
