---
layout: post
title: Instala programas en Haiku con HaikuPorts y HaikuPorter
description: Aprende a instalar programas en Haiku con HaikuPorter y HaikuPorts
keywords:
 - haiku
 - paquete
 - paqueteria
 - hpkg
 - pkgman
 - haikudepot
 - tutorial
---

Haiku introdujo recientemente su nuevo sistema de paquetería. Este dispone de varios métodos para obtener los programas. El método más sencillo es HaikuDepot, la aplicación gráfica con paquetes ya compilados listos para descargar e instalar con un click. Sin embargo hay mucho más software disponible en el árbol de recetas de Haiku, conocido como HaikuPorts, que usa un programa propio para su gestión llamado HaikuPorter. HaikuPorter no gestiona la instalación, sino la creación de los paquetes desde la fuentes originales.

![HaikuDepot]({{site.baseurl}}images/haiku-depot.png)

## Haikuports y Haikuporter

Haikuports es una colección se software en forma de recetas que dicen como se deben de compilar los programas pero no los almacena. Un sistema similar al de Gentoo y FreeBSD. Haikuports usa Haikuporter para construir los paquetes así que debemos instalar antes de nada Haikuports y Haikuporter

### Instalando Haikuporter

Instalar Haikuporter requiere que abras la terminal y obtengamos su código fuente

```
git clone https://bitbucket.org/haikuports/haikuporter
```

Ahora debemos configurarlo con nuestros datos

```
cd haikuporter
cp haikuports-sample.conf /boot/home/config/settings/haikuports.conf
ln -s /boot/home/haikuporter/haikuporter /boot/home/config/non-packaged/bin/
lpe /boot/home/config/settings/haikuports.conf
```

Tendremos que editar un archivo. Os pongo como tengo el mío

```
TREE_PATH="/boot/home/haikuports"
PACKAGER="Adrián Arroyo Calle <micorreo@gmail.com>"
ALLOW_UNTESTED="yes"
ALLOW_UNSAFE_SOURCES="yes"
TARGET_ARCHITECTURE="x86_gcc2"
SECONDARY_TARGET_ARCHITECTURES="x86"

```

Aunque en vuestro caso podeis poner "no" en ALLOW_UNTESTED y ALLOW_UNSAFE_SOURCES.

### Instalando Haikuports

Volvemos a nuestra carpeta y obtenemos el código

```
cd ~
git clone https://bitbucket.org/haikuports/haikuports.git --depth=10
```

## Usando Haikuporter y Haikuports

Ya estamos listo para construir cualquier paquete con Haikuporter, no solo los nuestros. Con esto podemos acceder a gran cantidad de software. El uso básico de haikuporter es 

```
haikuporter NOMBRE_DEL_PAQUETE
```

Aunque si las dependencias nos abruman podemos saltarnoslo

```
haikuporter NOMBRE_DEL_PAQUETE --no-dependencies
```

Los paquetes no se instalan automáticamente, se guardan en /boot/home/haikuports/packages y para instalarlos los debemos copiar a /boot/home/config/packages. También podemos compilar con GCC4 en vez de GCC2 si el programa lo soporta. Hay que añadir _x86 al final. Comprobemos que todo funciona con un paquete al azar

```
haikuporter cmake_haiku_x86
```

Tardará en actualizar la base de datos y pueden que nos salten errores de arquitecturas pero no hay que preocuparse. En mi caso, Haikuporter quería instalar paquetes del sistema ya que había versiones nuevas en haikuports. Sin embargo, como se que iba a tardar mucho cancelé y ejecuté

```
haikuporter cmake_haiku_x86 --no-dependencies
```

Convendría ahora instalar todo lo compilado

```
cp /boot/home/haikuports/packages/*.hpkg /boot/home/config/packages/
```

