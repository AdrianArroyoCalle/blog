---
layout: post
title: Notas de instalación de openSUSE Tumbleweed
description:
keywords:
 - opensuse
 - linux
 - ubuntu
 - instalar
---

He decidido darle una oportunidad a openSUSE Tumbleweed (la versión _rolling release_) ¿Podrá llegar a sustituir a Lubuntu? Solo hay una manera de averiguarlo. En este post simplemente voy a reunir todo lo que he hecho con el sistema hasta empezar a trabajar, tan solo por tenerlo como referencia. He decidido instalar [MATE](http://mate-desktop.org) por defecto.

## Descarga

He decidido descargar Tumbleweed directamente desde la [wiki de openSUSE](https://es.opensuse.org/openSUSE:Instalaci%C3%B3n_de_Tumbleweed). Concretamente el enlace que he usado es 64 bits, instalación de red.

* http://download.opensuse.org/tumbleweed/iso/openSUSE-Tumbleweed-NET-x86_64-Current.iso

Grabas la ISO y entramos al instalador

## Instalando

Nada más entrar cambiamos el idioma con F2 y seleccionamos el español. Pulsamos "Instalación". Tendremos una pantalla de carga para posteriormente aparecer el acuerdo de licencia, el idioma y la distribución de teclado. Comprueba que las teclas concuerden en la caja. Yo suelo comprobar "Ñ" y "/".

IMAGEN

Ahora openSUSE realiza comprobaciones y descarga la información de los repositorios

IMAGEN

En cuanto a las particiones he decidido tener una única para / y /home bajo BtrFS

IMAGEN

Y en la hora, simplemente Europa/España. En ajustes avanzados podemos elegir el servidor NTP. He aquí una lista:

* 0.opensuse.pool.ntp.org
* 1.opensuse.pool.ntp.org
* 0.europe.pool.ntp.org
* 2.es.pool.ntp.org
* clepsidra.tel.uva.es
* ntp1.tel.uva.es
* ntp2.tel.uva.es
* ntp.ubuntu.com
* hora.rediris.es
* cuco.rediris.es
* time.windows.com
* hora.roa.es

Yo he cogido este último, que es el oficial de España.

Como voy a instalar MATE, selecciono instalar entorno X mínimo. Creamos el usuario.

Ahora esperamos a que descargue todo, lo instale y reinicie. Ya en la nueva sesión entraremos al entorno IceVM. Abrimos XTerm para empezar lo bueno.

## Instalar MATE

```sh
sudo su
zypper ar http://download.opensuse.org/repositories/X11:/MATE:/Current/openSUSE_Tumbleweed MATE
zypper in -t pattern mate_basis
```

Mientras descargaba abrí YaST y en el módulo de NTP le fui añadiendo más servidores. Una vez haya finalizado, en YaST abrimos el módulo de _editor en /etc/sysconfig_

Vamos a Desktop->Window Manager->DEFAULT WM y ponemos el valor _mate-session_. Y en Desktop->Display manager->DISPLAYMANAGER ponemos _lightdm_. Ahora reiniciamos. Y ya podremos entrar en MATE. En MATE hay que ajustar el tamaño del monitor.

## Aplicaciones de Internet

```
zypper in MozillaFirefox MozillaThunderbird seamonkey
```

## Desarrollo

### Editores

```
wget http://atom.io/download/rpm -O atom.rpm
zypper in ./atom.rpm
zypper in geany
```

### Sistemas de control de versiones

```
zypper ar -f http://www.plasticscm.com/plasticrepo/plasticscm-common/openSUSE_12.3/ plasticscm-common
zypper ar -f http://www.plasticscm.com/plasticrepo/plasticscm-latest/openSUSE_12.3/ plasticscm-latest
zypper refresh
zypper in git cvs hg svn bzr plasticscm-complete osc
```

### Rust

```
curl -sSf https://static.rust-lang.org/rustup.sh | sh
```

### Node.js

```
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.25.4/install.sh | bash
nvm install stable
nvm use stable
npm install -g browserify http-server azure-cli jpm typescript grunt-cli tsd yo yuidocjs gulp-cli
npm login
```

### Ruby

```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install 2.2.1
gem install jekyll heroku rhc ronn github-pages
```

### C++

```
zypper in gcc-c++ cmake scons autoconf nasm patch
```

### GUI

```
zypper in libQt5OpenGL-devel libQt5Gui5-devel libQtQuick5-devel wxWidgets-3_0-devel libqt5-qtdeclarative-tools // FALTA ALGO para CMake y QML
```

### Java

```
zypper addrepo http://download.opensuse.org/repositories/devel:tools:building/openSUSE_Factory/devel:tools:building.repo
zypper refresh
zypper in maven
wget https://services.gradle.org/distributions/gradle-2.5-bin.zip
unzip gradle-2.5-bin.zip
# Añadir a .bashrc export PATH="$PATH:$HOME/gradle-2.5/bin"
```

### Multimedia

```
zypper addrepo http://download.opensuse.org/repositories/games:tools/openSUSE_Tumbleweed/games:tools.repo
zypper refresh
zypper in gimp inkscape ffmpeg ImageMagick sox optipng pandoc blender tiled aseprite
```

### Librerías de audio

```
zypper in portaudio-devel libvorbisfile3 alsa-devel libogg-devel libvorbis-devel
```

### Ogre, CEGUI, SFML2, OIS, SDL2, GLFW y GLEW

```
zypper addrepo http://download.opensuse.org/repositories/games/openSUSE_Tumbleweed/games.repo
zypper refresh
zypper in libOIS-devel libOgreMain-devel ogre-tools SDL2-devel SDL2_image-devel SDL2_gfx-devel SDL2_net-devel SDL2_ttf-devel SDL2_mixer-devel libglfw3 glew-devel sfml2-devel libfreetype6
// INSTALAR CEGUI
```

### Lenguajes embebidos

```
zypper in lua-devel squirrel-devel
```

### Herramientas de cloud

```
wget https://storage.googleapis.com/appengine-sdks/featured/google_appengine_1.9.24.zip
unzip google_appengine_1.9.24.zip 
# En .bashrc añadir al final export PATH=$PATH:~/google_appengine/
heroku login
rhc setup
```

### Otras librerías de interés

```
zypper in boost-devel sqlite3-devel
```

### Otros programas de interés

https://www.google.com/webdesigner/

```
zypper addrepo http://download.opensuse.org/repositories/CrossToolchain:avr/openSUSE_Tumbleweed/CrossToolchain:avr.repo
zypper refresh
zypper in nano
zypper in arduino
zypper in doxygen
zypper in dialog
zypper in fritzing
zypper in poedit
```

### RPMs caseros

```
zypper addrepo http://download.opensuse.org/repositories/devel:tools/openSUSE_Factory/devel:tools.repo
zypper refresh
zypper in rpmdevtools
rpmdev-setuptree
cd rpmbuild/SPECS
git clone https://github.com/AdrianArroyoCalle/rpm-specs .
rpmbuild -ba azpazeta.spec

### Clonar

Ya solo queda clonar de GitHub, BitBucket, Launchpad, Codeplex y demás sitios