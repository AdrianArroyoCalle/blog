---
layout: post
title: ¿Qué nos espera en Haiku Beta?
keywords:
 - haiku
 - os
 - sistema-operativo
 - beta
 - compilador
 - gcc
 - webpositive
 - beos
 - pkgman
 - blogstack
description: Ya queda poco para el lanzamiento de una nueva beta de Haiku. Veamos las novedades que aportará.
---

No sé si conoceis [Haiku](http://haiku-os.org). Se trata de un sistema operativo libre (bajo licencia MIT) que intenta ser un clon libre de BeOS siguiendo su filosofía. Podríamos compararlo a [Linux](http://kernel.org) respecto a UNIX o [ReactOS](http://reactos.org) respecto a Windows NT. El caso es que no comparte nada con otros sistemas operativos disponibles en el mercado y eso lo hace muy interesante. La historia de Haiku y BeOS es muy interesante y podeis encontrar mucha información al respecto que no voy a replicar. Sin embargo el desarrollo de Haiku siempre ha sido muy lento y ahora mismo estamos en los albores de la Beta 1 de Haiku. Después de 4 alphas bastante estables se van a atrever a lanzar la primera beta. ¿Por qué ahora? Vamos a ver las novedades que traerá Haiku para saber porque se ha decidido este importante paso.

![Haiku Desktop]({{ site.baseurl }}images/haiku-basic.png)

# Compilador actualizado

Haiku ya dispone de una vía rápida para obtener un compilador con las últimas características que se esperan de él. La versión que está instalada en mi máquina virtual tiene [GCC](http://gcc.gnu.org) 4.8.3 (publicado el 22 de mayo de 2014). Sin embargo no será el compilador por defecto. Durante mucho tiempo en Haiku solo se podía usar GCC 2.95 y va a seguir siendo el compilador por defecto. Las razones es que el código generado por este compilador son compatibles con el último BeOS. Actualmente en Haiku se ofrecen 4 descargas para x86: una usando solo GCC 2, otra usando solo GCC 2, una híbrida usando por defecto GCC 2 y otra híbrida usando por defecto GCC 4. Recomiendo la híbrida usando por defecto GCC 2.

![GCC 2 vs GCC 4]({{ site.baseurl }}images/haiku-gcc.png)

# Nuevas arquitecturas

Relacionado con lo anterior Haiku ha podido ser portado a arquitecturas diferentes como PPC, ARM, m68k y x86_64. Decir que la versión ARM es todavía muy prematura aunque se han hecho grandes avances en ello.

# Navegador web actualizado

Haiku antes disponía de [Firefox](http://getfirefox.com). Un día Firefox decidió usar Cairo como librería de renderizado. Esto supone un aumento de velocidad para Firefox en aquel momento pero rompe el port existente con BeOS/Haiku/ZETA. Cairo al igual que [GTK](http://gtk.org) nunca han estado soportados de manera oficial en BeOS y con GTK2 el port que había dejó de funcionar. Desde entonces Haiku ha sufrido la carencia de navegadores decentes. Algo más grave si tenemos en cuenta la importancia de HTML5. Así pues ahora mismo en 2014 tenemos los siguientes navegadores gráficos actualizados funcionando sobre Haiku:

 * [Qupzilla](http://qupzilla.com)
 * [NetSurf](http://netsurf-browser.org)
 * WebPositive

Pero también tendríamos versiones antiguas de:

 * Firefox (BeZilla)
 * Opera
 * NetPositive

Qupzilla usa WebKit y Qt, además es bastante inestable. Y su interfaz no es la típica de Haiku. Por eso no es muy usado por la comunidad. NetSurf es bastante estable ya que es una de las plataformas a las que está enfocado, pero NetSurf es un navegador muy pequeño comparado con otros. Usa su propio motor y es muy ligero pero muy poco compatible. De hecho no soporta JavaScript. Nos queda WebPositive, el navegador oficial de Haiku. Usa WebKit pero usando una interfaz nativa de Haiku y con llamadas propias al sistema. Está implementado con la API BWebView para que otras aplicaciones lo puedan usar. Es el navegador más avanzado con un soporte decente para HTML5 y JavaScript. Le sigue faltando WebGL y alguna que otra API pero el soporte de SVG, Canvas 2D, Audio y muchas otras características es bastante decente. Mencionar también que Haiku soporta [OpenJDK](http://openjdk.java.net/projects/haiku-port/) 7 como un port que funciona decentemente.

![WebPositive html5test.com score]({{ site.baseurl }}images/haiku-webpositive.png)

# Sistema de paquetería

Quizá la característica más importante para Haiku ha sido el sistema de paquetería. Un gran sistema que se podría calificar como de lo mejores en mucho tiempo. Esto no quiere decir que Haiku no tuviese sistema de paquetería antes, realmente tenía uno muy simple pero que servía, eran los OptionalPackages. Sin embargo el concepto de sistema de paquetería ha sido rediseñado para Haiku y el resultado es bastante bueno. Lo primero que vemos son dos programas dedicados a gestionar la paquetería para los usuarios, el primero es __pkgman__, el de línea de comandos y el segundo es __HaikuDepot__, para realizar todas las operaciones desde la línea de comandos. Esta es una cosa que me gusta de Haiku, cuidan tanto la línea de comandos como la interfaz gráfica y quieren que tengas las mismas características en cualquier entorno. Respecto a los paquetes, usan una extensión .HPKG y para instalarlos los tendremos que copiar en nuestra carpeta de usuario (actualmente es /boot/home/config/packages) y ya está.

> ¿Sólo hay que copiar los paquetes? ¿ya está?

Sí, solo hay que copiar. La magia reside en el [PackageFS](https://dev.haiku-os.org/wiki/PackageManagement/Infrastructure), un sistema de archivos que surge de la lectura del HPKG y montando los ficheros en sus respectivos lugares en modo lectura. Para ello hay un demonio vigilando la carpeta y si recibe cambios los descomprime y los monta en el sistema de ficheros. Esto influye a que ahora solo la carpeta /boot/home pueda ser escrita simple y llanamente porque el resto de carpetas (/boot/system es la única que veo) están montadas en modo solo lectura de los paquetes del sistema. Estos estan localizados en /boot/system/packages. En esta carpeta también podremos escrbir y borrar pero teniendo en cuenta que el HPKG con el kernel también está ahí conviene tener cuidado con la carpeta. Y la cosa se hace más graciosa cuando comprobamos que cada paquete tiene cargada su instancia del sistema operativo y sus librerías (/boot/system/package-links). La verdad es que las instalaciones son muy rápidas y funciona por lo general. En un próximo post enseñaré a crear paquetes para Haiku   (usando HPKG) de dos métodos distintos y que ocurre con la gestión de dependencias. También crearemos un repositorio y veremos como hacer Haiku un sistema operativo 100% rolling release usando los HPKG.

![Haiku Depot]({{ site.baseurl }}images/haiku-depot.png)

# Conclusión

Me habré dejado cosas seguro y además la compatibilidad con aplicaciones de terceros ha aumentado. Haiku se acerca a su primera beta y las cosas se ponen muy pero que muy interesantes.