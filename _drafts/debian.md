---
layout: post
title: Entrando en el juego de Debian Sid
description: 
keywords:

---

He decidido cambiar de distro. No ha sido elección fácil pero lo necesitaba, tenía problemas por estar usando software desactualizado en Ubuntu 14.04 LTS y tenía que hacer algo. No me gusta actualizar Ubuntu cada 6 meses, pero tampoco quiero alejarme del mundo Ubuntu. Arch está bien, pero no me gusta la idea de Yaourt y no usa paquetería DEB. Así que pensándolo mucho he decidido tirar hacia Debian Sid, es decir, la versión rolling release de Debian.

## Instalando

Descargue la imagen [mini.iso](http://ftp.es.debian.org/debian/dists/unstable/main/installer-amd64/current/images/netboot/mini.iso)

Advanced Options -> Expert Install

Elegir idioma -> Español de España UTF8

Configurar Red -> DHCP y valores por defecto

Configurar réplica -> debian, WORKGROUP, ftp, "ftp.es.debian.org", "/debian/" y sin rellenar el proxy. Elegir SID

Descargar componentes

Configurar hora -> hora.roa.es

Detectar discos

Configurar usuarios -> Con SUDO (sin root)

Particionar -> TODO en ext4

Instalar sistema base

Configurar gestor de paquetes -> Usar software no libre

Instalar paquetes -> PopCon -> Popularity-contest Sí -> MATE

Instalar GRUB

## Configurando el sistema

Tema, monitor y abrimos terminal

netselect-apt

Firefox, Thunderbird, SeaMonkey, Instantbird, deb.opera.com, Chromium, Web Designer, Launchpad Adrián, Launchpad Divel, PlasticSCM, GDebi

apt install apt-file command-not-found software-properties-common

Receive keys from KeyServer

Install GPG

Heroku