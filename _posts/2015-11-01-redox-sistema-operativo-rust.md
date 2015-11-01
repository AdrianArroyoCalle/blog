---
layout: post
title: Redox, el sistema operativo escrito en Rust
description: Redox es un sistema operativo escrito enteramente en Rust. Un sistema que solamente implementa nuevos conceptos, sin importarle la compatibilidad.
keywords:
 - rust
 - programacion
 - blogstack
 - linux
 - ubuntu
 - sistemas-operativos
---

Hoy voy a hablar de [Redox](http://www.redox-os.org), un sistema operativo relativamente nuevo, escrito totalmente en [Rust]({{ site.baseurl }}{% post_url 2015-07-17-rust-essentials-resena-del-libro %}). Redox sigue la filosofía UNIX y la mayor parte del sistema es accesible a través del sistema de archivos. En Redox esta función la cumplen las URL. Además, es un sistema operativo seguro, una de las principales características de Rust. En Redox además todas las aplicaciones corren en modo sandbox.

## Compilar Redox

Redox se distribuye únicamente a través del código fuente. En el futuro habrá imágenes ISO. Funciona en x86 de 32 bits y se está trabajando en el soporte x86_64 de 64 bits. En Debian/Ubuntu hay que seguir estas instrucciones.

```
git clone http://github.com/redox-os/redox
cd redox
cd setup
./ubuntu.sh
./binary.sh
cd ..
make all
```

Una vez haya terminado podemos ejecutar Redox en una máquina virtual. Yo voy a usar QEMU.

```
sudo apt install qemu-system-x86 qemu-kvm
make qemu
# make qemu_no_kvm
```

## Un vistazo rápido

![Redox]({{ site.baseurl }}images/Redox1.png)
![Redox]({{ site.baseurl }}images/Redox2.png)
![Redox]({{ site.baseurl }}images/Redox3.png)

Entramos directamente al escritorio gráfico, no ha hecho falta seleccionar nada. Redox es un sistema operativo diseñado con la interfaz ya en mente, no como los sistemas UNIX donde el sistema gráfico viene de terceras partes (X11, Quartz, DirectFB, Wayland, Mir, ...).

## Aplicaciones

Redox dispone de dos editores, el editor básico (que como vemos, el archivo que abre por defecto es none:/, el concepto de todo es una URL es básico en Redox) y Sodium, un editor más avanzado (tipo Vi o Emacs). Tenemos un explorador de archivos, un terminal de Lua, un terminal de comandos, un visor de imágenes y una aplicación de prueba de SDL. Han sido portados DOSBox, zlib, libpng, libiconv y FreeCiv a Redox. GCC, newlib y binutils están muy cerca de funcionar nativamente pero todavía hay algunos problemas.

## Componentes

__Concepto de URL__. En Redox todo debe ser una URL. Los registros se almacenan en log://, los daemons usan la interfaz bus://, /dev/null aquí es none://.

__fired__ es el sistema de arranque (SysV, systemd o Upstart en Linux), escrito totalmente en Rust. Usa ficheros Toml para la configuración, recurre a la paralelización pero solo tiene como dependencia el kernel Redox y no hace más cosa que el sistema de arranque (esto es un mensaje indirecto contra systemd).

__ZFS__. El sistema de archivos principal será el magnífico [ZFS](https://wiki.archlinux.org/index.php/ZFS) de Sun/Oracle. Todavía está en desarrollo pero el trabajo se está concentrando exclusivamente en ZFS.

__Oxide__. Oxide es el gestor de paquetes de Redox. Todavía muy verde.

__Lua__. Lua es el lenguaje usado para realizar scripts en Redox.

__Ion__. Un shell más compatible con UNIX que Lua. Inspirado en fish y zsh.

__Bohr__. El sistema gráfico de Redox.

__Orbital__. El sistema de ventanas de Redox.