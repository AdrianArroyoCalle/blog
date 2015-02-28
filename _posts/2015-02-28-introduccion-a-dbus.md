---
layout: post
title: Introducción a D-Bus
description: D-Bus se ha vuelto un componente muy importante en Linux
keywords:
 - dbus
 - linux
 - ubuntu
 - componentes
 - sistemas-operativos
 - javascript
---

> ___Esta entrada la he realizado originalmente para el blog [DesdeLinux](http://blog.desdelinux.net)___

![Esquema de D-Bus]({{ site.baseurl }}images/dbus.png)

Si llevas algún tiempo en Linux quizás te hayas llegado a preguntar que es [D-Bus](http://dbus.freedesktop.org). D-Bus es un componente incorporado no hace mucho a las distribuciones de escritorio en Linux que previsiblemente jugará un papel muy importante para la programación en Linux.

## ¿Qué es D-Bus?

D-Bus es un sistema de comunicación entre aplicaciones de muy diverso origen. Con este sistema podremos llamar incluso a aplicaciones privativas (si estas implementan D-Bus). No juega el mismo papel que una librería pues una librería no es un programa independiente y la librería forma parte de tu ejecutable. La idea de D-Bus está inspirada en los objectos OLE, [COM](http://es.wikipedia.org/wiki/Component_Object_Model) y ActiveX de [Windows](http://windows.com). Los objetos COM de Windows ofrecen una manera sencilla de llamar a cualquier programa desde otro programa llegando incluso a poder incrustarse visualmente uno dentro de otro sin necesidad de usar el mismo lenguaje de programación. D-Bus no llega tan lejos pero ofrece esa comunicación de la que UNIX carecía.

## ¿Por qué es importante D-Bus?

D-Bus es importante dada la gran diversidad de lenguajes que pueden funcionar en Linux y la gran diversidad también de librerías. Pongamos un ejemplo práctico. Yo quiero mandar una notificación al sistema notify-osd de [Ubuntu](http://ubuntu.com) desde mi aplicación en Node.js. Primero tendría que ver que librería ofrece esa funcionalidad en el sistema, libnotify en este caso, y después debería hacer unos bindings para poder llamar la librería programada en C desde JavaScript. Además imaginemos que queremos hacer funcionar nuestra aplicación con un escritorio que no usa libnotify para las notificaciones.

## Usando D-Bus

Entonces hemos decidido que vamos a usar D-Bus para crear la notificación de nuestra aplicación en JavaScript.

{% include gist.html id="99d2ea6db92e90a54e2c" %}

Hay 2 tipos de buses en D-Bus, un D-Bus único al sistema y un D-Bus para cada sesión de usuario. Luego en D-Bus tenemos servicios que son "los nombres de los proveedores D-Bus", algo así como las aplicaciones D-Bus. Después en una estructura como de carpeta están los objetos que puede tener ese servicio o instancias y finalmente la interfaz es la manera de interactuar con los objetos de ese servicio. En este caso es muy redundante pues el servidor de notificaciones es muy simple.

## ¿Quién usa D-Bus?

Más programas de los que imaginas usan D-Bus. Algunos servicios de D-Bus solo por nombrar ejemplos son:

 * com.Skype.API
 * com.canonical.Unity
 * org.freedesktop.PolicyKit1
 * org.gnome.Nautilus
 * org.debian.apt
 * com.ubuntu.Upstart

Para averiguar todos los servicios de D-Bus que tienes instalados puedes usar [D-Feet](http://wiki.gnome.org/action/show/Apps/DFeet)

![D-Feet]({{ site.baseurl }}images/D-Feet.png)
