---
layout: post
title: Tutorial de CMake
description: Tutorial en español con ejemplos prácticos para CMake 3.2
keywords:
 - cmake
 - tutorial
 - linux
 - programacion
 - blogstack
 - ubuntu
---

Llevo varios años usando de forma habitual CMake. Sin embargo me doy cuenta que alguien que quiera empezar a usar este sistema va a encontrarse con documentación confusa.

> _1º Regla de CMake. La documentación puede ser confusa_

## ¿Qué es CMake?

CMake se trata de una herramienta multiplataforma para generar instrucciones de compilación del código. No sustituye a las herramientas de compilación como Make o MSBuild, sino que nos proporciona un único lenguaje que será transformado a las instrucciones del sistema operativo donde nos encontremos. Sería un sustituto de Autotools.

![Flujo de trabajo con CMake]({{ site.baseurl }}images/cmake-dia.svg)

Las ventajas son que no tenemos que tener varios archivos para gestionar la compilación. Usando CMake podemos generar el resto. Actualmente CMake (3.2.3) soporta:

* Unix Make
* Ninja
* CodeBlocks
* Eclipse CDT
* KDevelop
* Sublime Text 2
* Borland Make
* MSYS Make
* MinGW Make
* NMake
* NMake JOM
* Watcom WMake
* Kate
* CodeLite
* Xcode
* Visual Studio (desde el 6 hasta 2013)

## Usando CMake

En CMake las configuraciones estan centralizadas por defecto en un archivo llamado CMakeLists.txt. Este se encuentra en la carpeta central del proyecto. Normalmente con CMake los proyectos se construyen en una carpeta diferente de la que tenemos el código fuente. Es corriente crear una carpeta `build` en lo alto del proyecto. Así si tenemos un proyecto con CMake ya descomprimido haríamos lo siguiente.

```sh
mkdir build
cd build
cmake ..
# make o ninja o nmake o lo que toque
```

También puedes usar la aplicación gráfica. Muy cómoda cuando debamos modificar las configuraciones.

![Aplicación gráfica de CMake]({{ site.baseurl }}images/cmake-gui.png)

Podemos ajustar las variables de CMake desde la interfaz de usuario, usando el modo interactivo de la línea de comandos (`cmake .. -i`) o usando flags cuando llamamos a CMake (`cmake .. -DCMAKE_CXX_FLAGS=-std=c++11`)

## El archivo CMakeLists.txt

Ya estamos listos para crear nuestro primer archivo de configuración de CMake.

![Proyecto de prueba]({{ site.baseurl }}images/proyecto.svg)

Vamos a ir viendo distintas versiones del archivo donde voy a ir añadiendo diferentes tareas. Estate atento a los comentarios de los archivos

#### Compilar como programa main.cpp

{% highlight cmake %}
PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
# Indicamos la versión mínima que necesitamos de CMake

SET(MiProyecto_SRC "src/main.cpp")
# Creamos la variable MiProyecto_SRC y le asignamos el valor "src/main.cpp" que es la ubicación de nuestro archivo.
# Por defecto las variables son listas o arrays
# Si tenemos dos archivos sería SET(MiProyecto_SRC "src/main.cpp"
"src/segundo.cpp")
# Se permite multilínea

ADD_EXECUTABLE(MiProyecto ${MiProyecto_SRC})

# Se creará un ejecutable llamado MiProyecto en Linux o MiProyecto.exe en Windows.
# Se hace referencia a las variables con ${NOMBRE_VARIABLE}.

{% endhighlight  %}

Y ya está. Si quieres saber las flags que se usaran al llamar al compilador mira [algunas variables interesantes](#algunas-variables-interesantes)


## Trabajar con opciones y condicionales

CMake permite ajustar muchas opciones como hemos visto con el asistente gráfico de CMake. Sin embargo no todas las variables se muestran ahí. Solo son modificables las que nosotros marquemos explícitamente. Se usa OPTION()

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(MiProyecto_SRC "src/main.cpp")

OPTION(EXPERIMENTAL_FEATURE "Activar característica experimental" OFF)
# OPTION(NOMBRE_VARIABLE DESCRIPCION_LEGIBLE VALOR_POR_DEFECTO)
# ON/OFF es la pareja de valores booleanos en CMake. TRUE/FALSE también es correcto

IF(EXPERIMENTAL_FEATURE) # El condicional más básico
	LIST(APPEND MiProyecto_SRC "experimental_feature.cpp")
	# Añadimos un elemento a la lista
	# También se puede hacer con
	# SET(MiProyecto_SRC ${MiProyecto_SRC} "experimental_feature.cpp")
ENDIF()

ADD_EXECUTABLE(MiProyecto ${MiProyecto_SRC})

{% endhighlight  %}

## Usar librería estática

{% highlight cmake %}
PROJECT(MiProyecto C CXX)
# Podemos marcar opcionalmente los lenguajes para que CMake busque los compiladores
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(MiProyecto_SRC "src/main.cpp")
SET(Lib_SRC "lib/lib.cpp")

ADD_LIBRARY(Lib STATIC ${Lib_SRC})
# El comando es exactamente igual que ADD_EXECUTABLE, pero marcamos si STATIC o SHARED
ADD_EXECUTABLE(MiProyecto ${MiProyecto_SRC})
TARGET_LINK_LIBRARIES(MiProyecto ${Lib})
# Necesitamos "unir" la librería con nuestro ejecutable
# Si necesitamos una librería tal cual usamos su nombre
# TARGET_LINK_LIBRARIES(MiProyecto pthread)
# Se pueden hacer las llamadas que se quiera a TARGET_LINK_LIBRARIES

{% endhighlight  %}

## Usar librería dinámica

{% highlight cmake %}
PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(MiProyecto_SRC "src/main.cpp")
SET(Lib_SRC "lib/lib.cpp")

ADD_LIBRARY(Lib SHARED ${Lib_SRC})
ADD_EXECUTABLE(MiProyecto ${MiProyecto_SRC})
TARGET_LINK_LIBRARIES(MiProyecto ${MiProyecto_SRC})

{% endhighlight  %}

## Seleccionar archivos de forma masiva

Usar SET para los archivos es muy fácil de entender, pero es posible que no queramos mantener una lista explícita del código fuente.

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

FILE(GLOB MiProyecto_SRC "src/*.cpp")
# FILE GLOB selecciona todos los archivos que cumplan la característica y los almacena en MiProyecto_SRC
# GLOB no es recursivo. Si lo necesitas, usa GLOB_RECURSE

ADD_EXECUTABLE(MiProyecto ${MiProyecto_SRC})

{% endhighlight  %}

Esto tiene un inconveniente y es que CMake no detecta automáticamente si hay nuevos archivos que cumplen la característica, por lo que hay que forzar la recarga.

## Copiar, crear, eliminar y descargar archivos

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

FILE(GLOB MiProyecto_SRC "src/*.cpp")

# Copiar archivos
FILE(COPY "MiArchivo.cpp" DESTINATION mi-carpeta)
# COPY usa como destino siempre una carpeta
# Se puede crear con FILE(MAKE_DIRECTORY mi-carpeta)

# Crear archivos

FILE(WRITE "Generado.txt" "Este archivo ha sido generado por CMake\nLos archivos son: ${MiProyecto_SRC}")

# Borrar archivos 

FILE(REMOVE "Generado.txt")
# No es recursivo, REMOVE_RECURSE sí lo es

# Descargar archivos

FILE(DOWNLOAD http://mi-servidor.com/archivo.tar.gz archivo.tar.gz)
# Podemos mostrar el progreso
# FILE(DOWNLOAD http://mi-servidor.com/archivo.tar.gz archivo.tar.gz SHOW_PROGRESS)
# Comprobar la suma MD5
# FILE(DOWNLOAD http://mi-servidor.com/archivo.tar.gz archivo.tar.gz EXPECTED_MD5 LaSumaMD5)
# Usar SSL
# FILE(DOWNLOAD http://mi-servidor.com/archivo.tar.gz archivo.tar.gz TLS_VERIFY ON)
# Guardar la información en un archivo de log
# FILE(DOWNLOAD http://mi-servidor.com/archivo.tar.gz archivo.tar.gz LOG descarga.log)


# Calcular suma de control

FILE(SHA256 archivo.tar.gz VARIABLE_CON_EL_HASH)

ADD_EXECUTABLE(MiProyecto ${MiProyecto_SRC})

{% endhighlight  %}

## Incluir archivos de cabecera

A veces es necesario incluir archivos de cabecera en localizaciones no estándar

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(MiProyecto_SRC 
"src/main.cpp" 
"src/algo_mas.cpp")

INCLUDE_DIRECTORIES("src/includes")
# Se añade el directorio a la ruta de búsqueda del compilador de turno

ADD_EXECUTABLE(MiProyecto ${MiProyecto_SRC})
{% endhighlight  %}


## Plugins de CMake

CMake es extensible a través de módulos. La instalación por defecto de CMake trae unos cuantos módulos, no obstante, podemos añadir módulos solo para nuestro proyecto. Los módulos tienen extensión .cmake. Normalmente se dejan en una carpeta llamada `cmake`.

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

LIST(APPEND CMAKE_PLUGIN_PATH "cmake")
# Simplemente añadimos un nuevo lugar a buscar. Veremos como se usan los módulos más adelante

ADD_EXECUTABLE(MiProyecto_SRC "src/main.cpp")

{% endhighlight  %}

## Mostrar información y generar errores

En ciertas situaciones querremos que no se pueda compilar el proyecto. MESSAGE es la solución.

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

MESSAGE("Información relevante")
MESSAGE(STATUS "Información sin relevancia")
MESSAGE(WARNING "Alerta, continúa la configuración y generación")
MESSAGE(SEND_ERROR "Error, continúa la configuración pero no generará")
MESSAGE(FATAL_ERROR "Error grave, detiene la configuración")

ADD_EXECUTABLE(MiProyecto "src/main.cpp")

{% endhighlight  %}

## Condicionales avanzados

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

## Con variables booleanas, es decir, ON/OFF, TRUE/FALSE

IF(NOMBRE_VARIABLE)
	MESSAGE("Algo es cierto")
ENDIF()

IF(NOT NOMBRE_VARIABLE)
	MESSAGE("Algo no es cierto")
ENDIF()

# La estructura completa es algo así

IF(CONDICION)
	
ELSEIF(CONDICION_2)

ELSE()

ENDIF()


# Se pueden aplicar operadores lógicos

IF(CONDICION AND CONDICION_2)

IF(CONDICION OR CONDICION_2)

# Con números y texto

IF(VAR_1 LESS VAR_2) # VAR_1 < VAR_2

IF(VAR_1 GREATER VAR_2) # VAR_1 > VAR_2

IF(VAR_1 EQUAL VAR_2) # VAR_1 === VAR_2

IF(VAR_1 MATCHES REGEX) # Se comprueba la expresión regular

# Además, CMake provee operadores para trabajar directamente con archivos, comandos y ejecutables

IF(DEFINED VAR_1) # ¿Está definida VAR_1?

IF(COMMAND CMD_1) # ¿CMD_1 es un comando de CMake?

IF(POLICY POL_1) # ¿La directiva POL_1 está activada?

IF(TARGET MiProyecto) # ¿Está definido el ejecutable MiProyecto?

IF(EXISTS src/main.cpp) # ¿Existe el archivo src/main.cpp?

IF(src/main.cpp IS_NEWER_THAN src/old/main.cpp) # ¿Es src/main.cpp más nuevo que src/old/main.cpp?

IF(IS_DIRECTORY src/includes) # ¿src/includes es un archivo o una carpeta?

{% endhighlight  %}

## Bucles

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(MiProyecto_SRC
"src/main.cpp"
"src/list.cpp"
"src/algomas.cpp")

FOREACH(Archivo_SRC IN MiProyecto_SRC)
	MESSAGE(STATUS "Procesando archivo ${Archivo_SRC}")
ENDFOREACH()

{% endhighlight  %}

## Submódulos

CMake usa un único archivo, pero quizá nos conviene repartir la configuración de CMake por varias carpetas entre zonas diferenciadas.

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ADD_SUBDIRECTORY(lib)
ADD_SUBDIRECTORY(src)

# src y lib tienen un CMakeLists.txt cada uno

{% endhighlight  %}

## Librerías externas

Una de las características más interesantes de CMake es que es capaz de encontrar librerías externas que necesite nuestro programa. Esta característica se implementa con plugins de CMake. Aquí voy a necesitar wxWidgets.

{% highlight cmake %}
PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

FIND_PACKAGE(wxWidgets) 
# El plugin debe llamarse FindPackagewxWidgets.cmake, este esta incluido en la distribución estándar de CMake
# En grandes librerías como wxWidgets, podemos pedir solo ciertos componentes
# FIND_PACKAGE(wxWidgets COMPONENTS core gl html base net)
# Podemos hacer que CMake no continúe si no encuentra la librería
# FIND_PACKAGE(wxWidgets REQUIRED)
# Si todo va bien, tenemos las variables wxWidgets_FOUND, wxWidgets_LIBRARIES y wxWidgets_INCLUDE_DIR

INCLUDE_DIRECTORIES(${wxWidgets_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(MiProyecto ${wxWidgets_LIBRARIES})

{% endhighlight  %}

## Definiciones

Podemos añadir directivas del preprocesador de C++ con CMake

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ADD_DEFINITIONS(-DPREMIUM_SUPPORT)
# Ahora #ifdef PREMIUM_SUPPORT en el código evaluará como cierto 

ADD_EXECUTABLE(MiProyecto "src/main.cpp")

{% endhighlight  %}

## Dependencias

Se pueden crear árboles de dependencias en CMake

{% highlight cmake %}
PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ADD_EXECUTABLE(MiProyecto "src/main.cpp")
ADD_EXECUTABLE(NecesitaMiProyecto "src/otro.cpp")

ADD_DEPENDENCY(NecesitaMiProyecto MiProyecto)
# NecesitaMiProyecto ahora depende de MiProyecto

{% endhighlight  %}

## Usando Qt

Ejemplo práctico usando CMake y Qt5 que es capaz de usar QML. Soporta archivos QRC de recursos. Requiere los plugins de Qt5

{% highlight cmake %}

PROJECT(ProyectoQt)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(CMAKE_AUTOMOC ON)
SET(CMAKE_INCLUDE_CURRENT_DIR ON)

FILE(GLOB ProyectoQt_SRC "src/*.cpp")

FIND_PACKAGE(Qt5Core REQUIRED)
FIND_PACKAGE(Qt5Widgets REQUIRED)
FIND_PACKAGE(Qt5Qml REQUIRED)
FIND_PACKAGE(Qt5Quick REQUIRED)

qt5_add_resources(Res_SRC "src/res.qrc")

ADD_EXECUTABLE(ProyectoQt ${ProyectoQt_SRC} ${Res_SRC})

qt5_use_modules(ProyectoQt Widgets Qml Quick)


{% endhighlight  %}

## Usando Java

CMake soporta Java, aunque no maneja dependencias como Maven o Gradle.

{% highlight cmake %}

PROJECT(ProyectoJava)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

FIND_PACKAGE(Java REQUIRED)
INCLUDE(UseJava)

SET(CMAKE_JAVA_COMPILE_FLAGS "-source" "1.6" "-target" "1.6")

FILE(GLOB JAVA_SRC "src/*.java")
SET(DEPS_JAR "deps/appengine.jar")

add_jar(ProyectoJava ${JAVA_SRC} INCLUDE_JARS ${DEPS_JAR} ENTRY_POINT "PuntoDeEntrada")

{% endhighlight  %}

## Comandos personalizados, Doxygen

En CMake podemos crear comandos personalizados. Por ejemplo, generar documentación con Doxygen

{% highlight cmake %}
PROJECT(Doxy)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ADD_CUSTOM_TARGET(doxygen doxygen ${PROJECT_SOURCE_DIR}/Doxyfile DEPENDS MiProyectoEjecutable WORKING_DIRECTORY ${PROJECT_SOURCE_DIR} COMMENT "Generando documentación" VERBATIM )

# Ahora puedes usar "make doxygen"
# Como es un TARGET cualquiera de CMake, puedes usar ADD_DEPENDENCY
# También puedes usar el plugin FindDoxygen para más portabilidad
{% endhighlight  %}

## Archivos de configuración

En Autotools es común usar un archivo con configuraciones en tiempo de compilación. Normalmente se trata de una cabecera con soporte para plantillas. En CMake se puede hacer.


config.hpp.in

{% highlight cpp %}
#ifndef CONFIG_HPP
#define CONFIG_HPP

#cmakedefine PREMIUM_SUPPORT

/* Si PREMIUM_SUPPORT está definido en CMakeLists.txt, se definirá aquí */

#define AUTHOR @AUTHOR@

/* Se definirá AUTHOR con el valor que tenga CMakeLists.txt de la variable AUTHOR */

#endif
{% endhighlight  %}

{% highlight cmake %}
PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

SET(AUTHOR "\"Adrian Arroyo Calle\"")

CONFIGURE_FILE(src/config.hpp.in src/config.hpp)


{% endhighlight  %}

## Instalar

CMake permite instalar también los programas

{% highlight cmake %}
PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ADD_EXECUTABLE(MiProyecto "src/main.cpp")

INSTALL(TARGETS MiProyecto DESTINATION bin/)
# Instala un ejecutable o librería en la carpeta seleccionada. Tenemos que tener en cuenta los prefijos, que son configurables en CMake.
# Si un programa en Linux suele ir en /usr/local/bin, debemos usar bin, pues /usr/local será añadido por CMake automáticamente
INSTALL(FILES ${ListaDeArchivos} DESTINATION .)
# Archivos normales
INSTALL(DIRECTORY mi-carpeta DESTINATION .)
# Copia la carpeta entera, conservando el nombre
# Se permiten expresiones regulares y wildcards
# INSTALL(DIRECTORY mi-carpeta DESTINATION . FILES_MATCHING PATTERN "*.png")

INSTALL(SCRIPT install-script.cmake)
# Un archivo de CMake que se ejecutará en la instalación

INCLUDE(InstallRequiredSystemLibraries)
# Importante si usas Windows y Visual Studio

# Y con esto se puede usar 'make install'


{% endhighlight  %}

## CPack

Pero `make install` es un poco incómodo. No se puede distribuir fácilmente. Aquí CMake presenta CPack, que genara instaladores. Yo soy reacio a usarlos pues son de mala calidad pero soporta:

* ZIP
* TAR.GZ
* TAR.BZ2
* TZ
* STGZ - Genera un script de Bash que ejecutará la descompresión y hará la instalación
* NSIS
* DragNDrop
* PackageMaker
* OSXX11
* Bundle
* Cygwin BZ2
* DEB
* RPM

CPack necesita que usemos el comando `cpack` en vez de `cmake`

{% highlight cmake %}

PROJECT(MiProyecto)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ADD_EXECUTABLE(MiProyecto "src/main.cpp")
INSTALL(TARGETS MiProyecto DESTINATION bin)

INCLUDE(CPack)
# Esto servirá para ZIP, TAR.GZ, TAR.BZ2, STGZ y TZ
# Para el resto deberás configurar manualmente unas cuantas variables necesarias
# http://www.cmake.org/Wiki/CMake:CPackPackageGenerators

{% endhighlight  %}

## Usando ensamblador

CMake soporta correctamente GNU ASM. Nasm requiere más trabajo.

{% highlight cmake %}
PROJECT(gnu-asm ASM C)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

ENABLE_LANGUAGE(ASM-ATT)

FILE(GLOB ASM_SOURCES "*.asm")
FILE(GLOB C_SOURCES "*.c")

ADD_LIBRARY(asm STATIC ${ASM_SOURCES})
ADD_EXECUTABLE(gnu-asm ${C_SOURCES})
TARGET_LINK_LIBRARIES(gnu-asm asm)
{% endhighlight  %}

## Algunas variables interesantes

|Variable|Información|
|--------|-----------|
|CMAKE_CURRENT_SOURCE_DIR|La ruta completa a la carpeta donde se encuentra CMakeLists.txt|
|CMAKE_MODULE_PATH|Las rutas para buscar plugins de CMake|
|PROJECT_BINARY_DIR|La carpeta que se está usando para guardar los resultados de la compilación|
|CMAKE_INCLUDE_PATH|Las carpetas de búsqueda de cabeceras|
|CMAKE_VERSION|Versión de CMake|
|CMAKE_SYSTEM|El nombre del sistema|
|CMAKE_SYSTEM_NAME|El sistema operativo|
|CMAKE_SYSTEM_PROCESSOR|El procesador|
|CMAKE_GENERATOR|El generador usado en ese momento|
|UNIX|Si estamos en Linux, OS X, BSD o Solaris será cierto|
|WIN32|Si estamos en Windows|
|APPLE|En OS X|
|MINGW| Usando MinGW|
|MSYS| Usando MSYS|
|BORLAND| Usando Borland|
|CYGWIN| Usando Cygwin|
|WATCOM| Usando OpenWatcom|
|MSVC| Usando Visual Studio|
|MSVC10| Usando Visual Studio 10|
|CMAKE_C_COMPILER_ID| El identificador de compilador de C|
|CMAKE_CXX_COMPILER_ID| El identificador de compilador de C++|
|CMAKE_COMPILER_IS_GNUCC| El compilador de C es una variante de GNU GCC|
|CMAKE_COMPILER_IS_GNUCXX| El compilador de C++ es una variante de GNU G++|
|CMAKE_BUILD_TYPE| La configuración Debug/Release que estamos usando|
|CMAKE_C_COMPILER| La ruta al compilador de C|
|CMAKE_C_FLAGS| La configuración del compilador de C|
|CMAKE_C_FLAGS_DEBUG| La configuración del compilador de C solo si estamos en la configuración Debug|
|CMAKE_C_FLAGS_RELEASE| La configuración del compilador de C solo si estamos en la configuración Release|
|CMAKE_SHARED_LINKER_FLAGS| La configuración del compilador para librerías compartidas|
|BUILD_SHARED_LIBS| Por defecto en ADD_LIBRARY, las librerías son compartidas. Podemos cambiar esto|

Muchas más en la [wiki de CMake](http://www.cmake.org/Wiki/CMake_Useful_Variables)

## RPath

El RPath es importante en los sistemas UNIX. Se trata de cargar librerías dinámicas que no están en directorios estándar.

{% highlight cmake %}
SET(CMAKE_SKIP_BUILD_RPATH  FALSE)
SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE) 
SET(CMAKE_INSTALL_RPATH "$ORIGIN")
SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
{% endhighlight  %}

Esto hará que los ejecutables construidos en UNIX puedan cargar librerías desde la carpeta donde se encuentran. Al estilo Windows.
