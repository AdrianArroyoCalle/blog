---
layout: post
title: La Odisea de una aplicación comercial hecha en Ogre y CEGUI
keywords:
 - blogstack
 - ogre
 - cegui
 - linux
 - paqueteria
---

Últimamente he estado concentrado en una tarea que considero extenuante, por la falta de información, y por la abundancia de respuestas que no aportan nada al caso. El dilema en cuestión es la distribución de binarios en Linux de una aplicación privativa, concretamente un juego hecho en [OGRE](http://ogre3d.org) y [CEGUI](http://cegui.org.uk). Y la verdad es que la odisea es larga. Así que he decidido comparar todas las opciones, sus pros y sus contras.

![Ogre - Wikimedia]({{ site.baseurl }}/images/OGRE.png)

## Opciones

Las opciones que he valorado para comparar son:

 * Paquetería nativa DEB, RPM y TAR.XZ
 * Distribuir un TAR.GZ binario
 * *Estatificar* (palabro inventado) el binario
 * Paquetería multi-distro, Autopackage, Listaller

## Paquetería nativa DEB, RPM y TAR.XZ

Esta opción, es a priori la más conveniente. El usuario dispondrá de un bonito paquete nativo (que se podrá actualizar) y se le gestionarán las dependencias, por ello ahorrará espacio en disco. Además tendrá una integración real con el sistema, lo podrá desinstalar desde donde acostumbra a desinstalar y el juego le aparecerá en los menús. Sin embargo los problemas salen enseguida, por una parte tienes que centrarte en ofrecer varios sistemas de distribución. Por otra parte, los paquetes nativos suelen no llevarse muy bien con otros paquetes de otras arquitecturas, ya que en algunos casos se nos pedirá instalar prácticamente el sistema de 32 bits encima del de 64, cuando realmente no es necesario. Además el tema de las dependencias es un arma de doble filo, pues en el caso de OGRE y CEGUI, o no hay, o están desfasadas. Así pues nuestro paquete puede quedarse inservible pronto. Y una peculiaridad de OGRE, resulta que tenemos que definir en plugins.cfg la localización de los plugins que usemos (normalmente con definir el de OpenGL ya sirve), pero la localización de esos plugins puede estar dispersa entre sistemas y arquitecturas. Con lo que deberíamos modificar el fichero plugins.cfg en cada sistema y arquitectura.

## Distribuir un TAR.GZ binario

Visto lo anterior, parece ser más cómodo distribuir un TAR.GZ binario. Muchas aplicaciones como [Oracle Java](http://java.com) o [Mozilla Firefox](http://getfirefox.com) son distribuidas desde el sitio oficial usando este sistema. Sin embargo, y aunque pueda parecer una buena idea, tiene algún que otro inconveniente. En primer lugar debemos intentar usar librerías estáticas. Si las librerías que usamos tienen esa opción, correcto. Puede que esas librerías dependan en otras que no puedan ser estáticas, y aunque lo fueran, añadirían más carga al ejecutable y complejidad en la compilación. Si dependemos de librerías compartidas las podemos poner en una carpeta que tengamos dentro del TAR.GZ y usar RPATH con $ORIGIN o LD\_LIBRARY\_PATH. El caso es que hay ciertas herramientas que nos pueden servir para ello. Por ejemplo [_cpld_](http://codevarium.gameka.com.br/deploying-cc-linux-applications-supporting-both-32-bit-and-64-bit/) nos puede servir para copiar todas las dependencias. El problema es que el proceso no puede ser automatizado completamente ya que el script no puede diferenciar una dependencia base de Linux de una que realmente debamos distribuir. Así que despúes de usar la herramienta nos tocará volver a revisar los ficheros que ha copiado ya que habrá copiado libc, libm, libpthread, libX11 y otras que posiblemente no necesitemos. Pero si no las copiamos podríamos tener problemas en sistemas de 64 bits. Una solución efectiva consiste en hacer un pequeño script que cargue las librerías según el sistema en el que estemos, habiendo usado el script en un sistema de 32 bits y en otro de 64 bits. Esto puede parecer razonable, pero tanto OGRE como CEGUI usan una arquitectura basada en plugins. Estos plugins no pueden ser analizados por ninguna herramienta y deberemos saber manualmente que plugins tendremos que pasar a  el comprimido. Por supuesto debemos separar las dos arquitecturas. En OGRE es fácil pasar los plugins ya que por defecto se usa el fichero plugins.cfg para leer los plugins, pero CEGUI no tiene esa característica (o yo no la he encontrado). Sin embargo es una alternativa muy sólida.

## _Estatificar_

Una opción que encontré mientras buscaba una solución se puede llamarla como estatificar. Es un método poco común que coge las dependencias compartidas y las empaqueta en un único binario. No se debe confundir con compilación estática ya que _estatificar_ requiere un binario ya compilado con dependencias. Únicamente hay dos aplicaciones que hacen esta función, y las dos son del mismo creador, aunque difieren en el funcionamiento de base. Por un lado [Statifier](http://statifier.sourceforge.net/), open source y gratuita, trabaja a un modo más rudimentario; por otro lado, [Magic Ermine](http://www.magicermine.com), trabaja con un sistema más perfeccionado, es de pago pero tiene una demo gratuita para probar. Los resultados no eran muy buenos, Statifier modificó el binario de manera que ya no arrancaba, por otro lado Magic Ermine funcionaba correctamente, pero el plugin de OpenGL de OGRE usa libGL.so, y como es cargada dinámicamente, Magic Ermine no sabe que tenía que empaquetarla y como consecuencia falla con un bonito error.

## Paquetería multidistro

Autopackage, Listaller, 0install, ... Prometen mucho pero no funcionan bien. Autopackage ha sido descontinuado en favor de Listaller, Listaller se tiene que integrar con AppStream y PackageKit, pero esos mismos componentes no están finalizados, [Listaller falla más que una escopeta de feria en la práctica](https://bugs.launchpad.net/listaller/+bug/1361686) y la documentación es pésima. Realmente espero que mejoren ya que prometen mucho, pero no se cuando será realmente usable. 0install trabaja de otra manera y al menos en mi caso, fallaba y no podía siquiera empaquetar una simple aplicación. Esta opción quizá en otro momento, pero ahora no.

## Conclusión

Hemos visto 4 opciones. Dos de ellas no funcionaban bien en la práctica (estatificar y la paquetería multidistro), las otras dos eran tediosas, pero si se estudia al detalle puede funcionar bien. Así pues podemos elegir entre la paquetería nativa y el TAR.GZ binario con scripts de dependencias. Así pues cada cuál elija la que más le guste.
