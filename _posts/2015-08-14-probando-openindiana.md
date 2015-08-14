---
layout: post
title: Probando OpenIndiana
description: OpenIndiana sacó una versión nightly en marzo de 2015
keywords:
 - solaris
 - openindiana
 - os
 - sistemas-operativos
 - linux
 - ubuntu
 - blogstack
---

Me he decidido a instalar [OpenIndiana](http://openindiana.org). Para esto he usado la última nightly disponible fechada a 30 de marzo de 2015.

![OpenIndiana instalador]({{site.baseurl}}images/OpenIndianaInstall.png)

__OpenIndiana__ entra por defecto en GNOME 2 en modo Live. Desde allí podemos lanzar el instalador para instalarlo en el disco.

## Instalando paquetes

OpenIndiana usa __IPS__ como gestor de paquetes. Para poder instalar paquetes debemos usar los siguientes comandos

```sh
sudo su
pkg install git
pkg install gcc-48
```

Para buscar paquetes

```
pkg search -pr NOMBRE_PAQUETE
```

IPS puede estar desactualizado. Afortunadamente, ya que SmartOS y OpenIndiana comparten el kernel illumos es posible usar los paquetes de SmartOS. Para ello hay que instalar __pkgin__. Añadimos al PATH las rutas /opt/local/sbin y /opt/local/bin. Usamos el archivo __.profile__.

```
PATH=/opt/local/sbin:/opt/local/bin:$PATH
export PATH
```

Después usamos el instalador

```
curl http://pkgsrc.joyent.com/packages/SmartOS/bootstrap/bootstrap-2015Q2-x86_64.tar.gz | gtar -zxpf - -C /
```

Una vez hecho esto podemos actualizar la base de datos de pkgin

```
pkgin -y update
```

Y podemos instalar normalmente

```
pkgin in mercurial
pkgin in wxGTK30
```

De todos modos yo no instalaría ninguna aplicación GUI vía pkgin.

![OpenIndiana]({{site.baseurl}}images/OpenIndiana.png)