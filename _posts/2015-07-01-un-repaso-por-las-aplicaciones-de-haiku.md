---
layout: post
title: Un repaso por las aplicaciones de Haiku
description: Haiku dispone de un catálogo pequeño pero interesante de aplicaciones que merecen la pena ser vistas
keywords:
 - haiku
 - blogstack
 - linux
 - ubuntu
 - aplicaciones
 - review
---

__Haiku__ dispone de un catálogo pequeño pero interesante de aplicaciones que merecen la pena ser vistas. Voy a probar estas aplicaciones en una versión nightly recién descargada [del sitio de Haiku](http://download.haiku-os.org) (hrev49344)
Solo voy a usar los paquetes binarios. En [Haikuports](http://github.com/haikuports/haikuports) hay todavía más software, pero requiere compilación y puede estar desactualizado.


## HaikuDepot

Se trata de la tienda de aplicaciones de Haiku. Similar a __Ubuntu Software Center__. Desde aquí podemos instalar cientos de aplicaciones ya compiladas para Haiku. Además permite comentar los progranas con una valoración.
HaikuDepot dispone de una [versión web](http://depot.haiku-os.org)

![HaikuDepot]({{ site.baseurl }}images/haiku/HaikuDepot.png)
![HaikuDepot]({{ site.baseurl }}images/haiku/HaikuDepot2.png)

##### Instalar

HaikuDepot ya viene instalado en Haiku

## WonderBrush

[WonderBrush](http://yellowbites.com/wonderbrush.html) se trata del editor gráfico de Haiku para imágenes de mapa de bits como PNG, JPEG o BMP.

La ventana principal puede contener cualquier número de documentos llamados Canvas. Un canvas tiene asociado un nombre y una resolución por píxel además de muchas otras propiedades. También referencia a dos archivos, uno como formato de exportación y otro como formato nativo.
Cada canvas puede tener cualquier número de capas, actualmente representadas como una lista. Cada capa representa una imagen del tamaño del canvas. Dependiendo del método de fusión de capas, estas son unidas para formar la imagen final.

![WonderBrush]({{ site.baseurl }}images/haiku/WonderBrush.png)
![WonderBrush]({{ site.baseurl }}images/haiku/WonderBrush2.png)

##### Instalar

Lo puedes encontrar en [HaikuDepot](https://depot.haiku-os.org/#/pkg/wonderbrush/2/1/2/-/4/x86_gcc2?bcguid=bc338-FECF) o 

```
pkgman install wonderbrush
```

## Icon-O-Matic

Icon-O-Matic es la aplicación de gráficos __vectoriales__ nativa de Haiku. Trabaja con el formato __HVIF__ (Haiku Vector Icon Format) y está pensada para diseñar iconos principalmente. También exporta a PNG y SVG.

![Icon-O-Matic]({{ site.baseurl }}images/haiku/IconOMatic.png)

##### Instalar

Ya viene instalado por defecto en Haiku

## WebPositive

WebPositive es el navegador web por defecto en Haiku. Usa una versión especial de __WebKit__ adaptada a Haiku y algo retrasada en funcionalidad.

![WebPositive]({{ site.baseurl }}images/haiku-webpositive.png)
![Multiversos en WebPositive]({{ site.baseurl }}images/haiku/MultiversosHaiku.png)

##### Instalar

WebPositive ya viene instalado

## PoorMan

PoorMan es un ligero servidor HTTP totalmente gráfico.

![PoorMan]({{ site.baseurl }}images/haiku/PoorMan.png)

##### Instalar

PoorMan ya viene instalado por defecto en Haiku

## Vision

[Vision](http://vision.sourceforge.net) es un cliente IRC

![Vision]({{ site.baseurl }}images/haiku/Vision.png)

##### Instalar

Ya viene instalado por defecto en Haiku

## People

People es el gestor de contactos de Haiku

![People]({{ site.baseurl }}images/haiku/People.png)

##### Instalar 

Ya viene instalado por defecto en Haiku

## Album

Una aplicación para tratar los metadatos de las imágenes

![Album]({{ site.baseurl }}images/haiku/Album.png)

##### Instalar

En HaikuDepot o `pkgman install album`

## ArmyKnife

Una aplicación para tratar los metadatos de las canciones

![ArmyKnife]({{ site.baseurl }}images/haiku/ArmyKnife.png)

##### Instalar

En HaikuDepot o `pkgman install armyknife`

## BeAE

BeAE es una gran aplicación junto a __Wonderbrush__ e __Icon-O-Matic__ para la edición multimedia. En este caso podremos editar audio de manera muy intuitiva. En su momento fue una aplicación de pago para BeOS.

![BeAE]({{ site.baseurl }}images/haiku/BeAE.png)

##### Instalar

En HaikuDepot o `pkgman install beae`

## BePDF

El visor de documentos PDF de Haiku

![BePDF]({{ site.baseurl }}images/haiku/BePDF.png)

##### Instalar

En HaikuDepot o `pkgman install bepdf`

## BeShare

Haiku también dispone de un sistema de transferencia de archivos P2P propio. Se trata de __BeShare__ y esta es la implementación referencia. BeShare como no podía ser menos, tiene un magnífico soporte para búsquedas.

![BeShare]({{ site.baseurl }}images/haiku/BeShare.png)

##### Instalar

En HaikuDepot o `pkgman install beshare_x86`. Para permitir la conexión entre distintos sistemas operativos a las redes BeShare se creó [JavaShare](https://github.com/bvarner/javashare)

## BeZilla

El port de Mozilla Firefox para Haiku. Está muy desactualizado y no lo recomiendo.

![BeZilla]({{ site.baseurl }}images/haiku/BeZilla.png)

##### Instalar

En HaikuDepot o `pkgman install bezilla`

## MailNews

El port de Mozilla Thunderbird para Haiku. Está igual de desactualizado que BeZilla pero al tratarse de correo electrónico puedes tener menos problemas al usarlo.

![MailNews]({{ site.baseurl }}images/haiku/MailNews.png)
![MailNews]({{ site.baseurl }}images/haiku/MailNews-2.png)

##### Instalar

En HaikuDepot o `pkgman install mailnews`

## Beam

Se trata de un cliente de correo electrónico plenamente integrado en Haiku

![Beam]({{ site.baseurl }}images/haiku/Beam.png)

##### Instalar

En HaikuDepot o `pkgman install beam`

## BlogPositive

Una aplicación para escribir en blogs de WordPress y otros proveedores sin tener que usar el navegador

![BlogPositive]({{ site.baseurl }}images/haiku/BlogPositive.png)

##### Instalar

En HaikuDepot o `pkgman install blogpositive`

## CapitalBe

Una aplicación de contabilidad sencilla y fácil de empezar a utilizar. __GnuCash__, que es el que uso en Linux, es mucho más complejo de empezar a usar.

![Capital Be]({{ site.baseurl }}images/haiku/CapitalBe.png)
![Capital Be]({{ site.baseurl }}images/haiku/CapitalBe2.png)

##### Instalar

En HaikuDepot o `pkgman install capitalbe`

## Sum-It

Una sencilla hoja de cálcula para realizar operaciones no muy complejas. La mejor hoja de cálcula es la de GoBe Productive, pero sigue siendo un producto privado que no se puede adquirir.

![Sum It]({{ site.baseurl }}images/haiku/SumIt.png)

##### Instalar

En HaikuDepot o `pkgman install sum_it`

## Caya

Caya es una aplicación que unifica la mensajería instantánea el estilo de Pidgin. Soporta AIM, Google Talk, Jabber, Facebook, MSN y Yahoo.

![Caya]({{ site.baseurl }}images/haiku/Caya.png)

##### Instalar

En HaikuDepot o `pkgman install caya`

## LibreCAD

[LibreCAD](http://librecad.org) es una aplicación de CAD 2D escrita en Qt.

![LibreCAD]({{ site.baseurl }}images/haiku/LibreCAD.png)

##### Instalar

En HaikuDepot o `pkgman install librecad_x86`

## Pe

Pe es el editor de texto más usado en Haiku. Tiene resaltado de sintaxis y soporte para extensiones.

![Pe]({{ site.baseurl }}images/haiku/Pe.png)
![Pe]({{ site.baseurl }}images/haiku/Pe-2.png)

##### Instalar

Pe viene instalado por defecto en Haiku

## NetSurf

[NetSurf](http://www.netsurf-browser.org) es un navegador ligero que no implementa JavaScript. Tiene una arquitectura interna muy limpia. Todo está contenido y modularizado. Está diseñado pensando en Haiku, RISC OS y otros sistemas _desconocidos_, aunque en Linux también funciona.

![NetSurf]({{ site.baseurl }}images/haiku/NetSurf.png)

##### Instalar

En HaikuDepot o `pkgman install netsurf`

## BePodder

BePodder es una aplicación para escuchar tus podcasts favoritos por RSS

![BePodder]({{ site.baseurl }}images/haiku/BePodder.png)

##### Instalar

En HaikuDepot o `pkgman install bepodder`

## A-Book

Una aplicación de calendario con recordatorios


##### Instalar

En HaikuDepot o `pkgman install a_book`

## BurnItNow

Una aplicación gráfica y fácil de usar para grabar CDs de todo tipo (datos, audio, rescate, ...)

![Burn it now]({{ site.baseurl }}images/haiku/BurnItNow.png)

##### Instalar

En HaikuDepot o `pkgman install burnitnow_x86`

## Clockwerk

Ya hemos hablado de Wonderbrush, Icon-O-Matic y BeAE. Le toca el turno a __Clockwerk__, el editor de vídeo no linear open source que trabaja en Haiku.

![Clockwerk]({{ site.baseurl }}images/haiku/Clockwerk.png)

##### Instalar

En HaikuDepot o `pkgman install clockwerk`

## LMMS

LMMS es una completa suite de edición de audio pensada para Linux pero que funciona también en Haiku.

![LMMS]({{ site.baseurl }}images/haiku/LMMS.png)

##### Instalar

En HaikuDepot o `pkgman install lmms_x86`

## MilkyTracker

MilkyTracker es un programa para componer música de estilo 8 bits o tune.

![Milky Tracker]({{ site.baseurl }}images/haiku/MilkyTracker.png)

##### Instalar

En HaikuDepot o `pkgman install milkytracker`

## Paladin

Paladin nace con la idea de ser el IDE de referencia en Haiku. Trae plantillas y ejemplos y se integra con el resto de Haiku para no reduplicar esfuerzos. Por ejemplo, el editor de texto es Pe.

![Paladin]({{ site.baseurl }}images/haiku/Paladin.png)

##### Instalar

En HaikuDepot o `pkgman install paladin`

## QEMU

QEMU es un contenedor de máquinas virtuales open source que permite emular arquitecturas diferentes a la de nuestro ordenador. Con QEMU podemos ejecutar Linux dentro de Haiku.

##### Instalar

En HaikuDepot o `pkgman install qemu_x86`

## Yab IDE

Yab es un entorno que permite programar aplicaciones para Haiku en __BASIC__. Yab IDE es el IDE para este entorno espefífico.

![Yab IDE]({{ site.baseurl }}images/haiku/Yab.png)
![Yab IDE]({{ site.baseurl }}images/haiku/Yab2.png)

##### Instalar

En HaikuDepot o `pkgman install yab_ide`

## Juegos

En este apartado voy a mencionar algunos juegos disponibles para Haiku. Todos se pueden encontrar en HaikuDepot

![BeMines]({{ site.baseurl }}images/haiku/BeMines.png)

* BeLife - `pkgman install belife`
* BeMines - `pkgman install bemines`
* Critical Mass - `pkgman install criticalmass`
* DOSBox - `pkgman install dosbox_x86`
* Flare - `pkgman install flare_x86`
* FreedroidRPG - `pkgman install freedroidrpg_x86`
* LBreakout2 - `pkgman install lbreakout2`
* LMarbles - `pkgman install lmarbles`
* LTris - `pkgman install ltris`
* OpenTTD - `pkgman install openttd_x86`
* Pipepanic - `pkgman install pipepanic`
* Road Fighter - `pkgman install roadfighter`
* Rocks'n'diamonds - `pkgman install rocksndiamonds_x86`
* SDL Lopan - `pkgman install sdllopan`
* Slime Volley - `pkgman install slime_volley`
* Super Transball 2 - `pkgman install super_transball`
* XRick - `pkgman install xrick`
