---
layout: post
title: Crea tu primer paquete para Haiku
description: Aprender a crear tu primer paquete para Haiku
keywords:
 - haiku
 - paqueteria
 - haikuporter
 - haikuports
 - gcc
 - haikudepot
---

Hoy vamos a crear nuestro propio paquete para Haiku. Se trata de mi juego SuperFreeCell que diseñé para el Google Code-In 2014.

![SuperFreeCell]({{site.baseurl}}images/SuperFreeCell-1.png)


## Nuestra propia rama de desarrollo

Si queremos publicar nuestros cambios a Haikuports, debemos hacernos una cuenta en BitBucket y hacer un fork del repositorio. Esto se hace desde http://bitbucket.org/haikuports/haikuports y dándole al botón de fork o dividir. En mi caso creé el repositorio https://bitbucket.org/AdrianArroyoCalle/haikuports-superfreecell. Añadimos el repositorio a nuestra lista de orígenes en Git.

```
git remote add superfreecell https://bitbucket.org/AdrianArroyoCalle/haikuports-superfreecell
```

## Ubicando el juego en Haikuports

Nada más empezar tenemos que encontrar la categoría a la que pertenecerá el paquete. Cada carpeta dentro de la carpeta haikuports representa una categoría, que siguen el esquema de Gentoo. En mi caso creo que lo conveniente es "haiku-games". Dentro de esta carpeta creamos una con el nombre de nuestro paquete y allí almacenaremos la información sobre nuestro paquete. Estas carpetas deben tener al menos un archivo .recipe y pueden incluir las carpetas licenses y patches con licencias y parches adicionales respectivamente. En mi caso no usaremos ninguna de estas dos carpetas, así que creamos el archivo superfreecell-0.1.0.recipe . Es importante esta estructura para encontrar la versión fácilmente.

## El archivo .recipe

El archivo .recipe contiene la información necesaria de metadatos e instrucciones para compilar e instalar el programa en cuestión.

```
SUMMARY="Descripción de menos de 70 caracteres"
DESCRIPTION="
Descripción extensa del programa usando \
para separar entre renglones que no deben superar \
los 80 caracteres
"
HOMEPAGE="http://pagina-de-inicio.org.es"
SOURCE_URI="http://una-pagina.com/con-el-archivo-del-codigo-fuente.tar.gz" # Se admiten muchas variaciones aquí. Podemos usar git://, hg://, svn://, bzr://, ftp://, http:// y los formatos de compresión tar.gz, tar.bz2, zip. Se admiten combinaciones de protocolos.
LICENSE="MIT"
COPYRIGHT="Año y autor"
REVISION="1" # Siendo la misma versión del programa, revisiones del propio empaquetado
ARCHITECTURES="?x86 x86_gcc2 !x86_64" # Arquitecturas compatibles, siendo x86_gcc2 estable, x86 sin probar (untested) pero que debería ir y x86_64 incompatible
if [ $effectiveTargetArchitecture != x86_gcc2 ]; then
	ARCHITECTURES="$ARCHITECTURES x86_gcc2"
fi
SECONDARY_ARCHITECTURES="x86" # Arquitecturas secundarias
PROVIDES="
	miaplicacion$secondaryArchSuffix = $portVersion # Todos los paquetes se proveen a sí mismos
	app:miaplicacion$secondaryArchSuffix = $portVersion # además es una aplicación de Haiku accesible desde los menús
"

REQUIRES="
	haiku$secondaryArchSuffix # Bastante claro. Aquí vendrían librerías en tiempo de ejecución
"

BUILD_REQUIRES="
	haiku_devel$secondaryArchSuffix # Actualmente todos los Haiku tienen haiku_devel pero por si las moscas. Aquí vendrían librerías de desarrollo
"

BUILD_PREREQUIRES="
	cmd:gcc$secondaryArchSuffix # Aquí vendrían las herramientas de línea de comandos. El prefijo cmd: indica que se llama desde la línea de comandos
	cmd:ld$secondaryArchSuffix
	cmd:make # Hay herramientas que da igual en que arquitectura estén para funcionar correctamente
"

SOURCE_DIR="LA_CARPETA_CON_EL_CODIGO_FUENTE"

PATCH()
{
	# Aquí se ponen los parches que se puedan aplicar son sed
}
BUILD()
{
	# Las instrucciones de configuración y compilación. Si usamos autotools
	runConfigure ./configure
	make
	# Si usamos CMake
	cmake .
	make
	
}
INSTALL()
{
	# Los comandos para instalar la aplicación. Hay que tener cuidado con los directorios especiales de Haiku, que no son POSIX
	# Si usamos autotools y CMake
	make install
	
	# También podemos copiar manualmente
	mkdir -p $includeDir
	cp include/libreria.h $includeDir/
	# Hay unas cuantas variables de carpetas que podemos usar
	
	addAppDeskbarSymlink $appsDir/MiApplicacion
	# Es muy posible que el make install no instale los enlaces para mostrarse en el lanzador de aplicaciones de Haiku
}
```

Y este sería el caso más básico de receta que podemos hacer. Si empaquetamos librerías la cosa se complica un poco más ya que tenemos que distinguir la parte de ejecución de la parte de desarrollo y entonces tendremos secciones como PROVIDES_devel que es especifico al paquete de desarrollo. Hay otra manera de aplicar parches que es con patchsets. Nosotros editamos la aplicación hasta que funcione y Haikuporter nos generará un archivo con los cambios que hay que aplicar a las fuentes. Es el mejor método para software un poco más complejo.

![Receta de SuperFreeCell]({{site.baseurl}}images/SuperFreeCell-Recipe.png)

## Publicar cambios

Una vez hayamos comprobado que funciona, lo subimos a nuestra copia de Git.

```
git add haiku-games/superfreecell
git commit -m "SuperFreeCell 0.1.0"
git push superfreecell master
```

Y desde BitBucket hacemos una pull request o solicitud de integración


