---
layout: post
title: Proyecto Ceres
description: La mejora continua de la calidad es imprescindible
keywords: 
 - calidad
 - programacion
 - blogstack
 - firefox
 - addons
 - complementos
 - javascript
---

El círculo de Deming es una estrategia de mejora continua de la calidad. También tenemos DMAIC y Seis Sigma. Parece por tanto que la mejora continua de la calidad es importante dentro de cualquier proceso productivo.

![Esquema DMAIC]({{ site.baseurl }}images/DMAIC.jpg)

Parte de mi software más exitoso de cara al público han sido las extensiones que he ido desarrollando para Firefox. Ayudan a la gente y además gano un dinerillo. Recibes feedback fácilmente e incluso me han propuesto ideas de desarrollo de nuevos complementos. Es algo agradable si sale bien, pero no he tenido tiempo últimamente para diseñar nuevas extensiones o mejorar las existentes. Así que algunas extensiones dejaron de ser tan funcionales y decidí que requerían pasar por un proceso de mejora continua de calidad. El Proyecto Ceres.

![Esquema DMAIC - otra versión]({{ site.baseurl }}images/DMAIC-2.png)

Este proyecto busca actualizar las extensiones para una mejor experiencia de uso. El registro de cambios es voluminoso, aunque en muchos casos la solución adoptada para un complemento es válida para otro.

## Lista de cambios

* [DivTranslate](https://addons.mozilla.org/es/firefox/addon/divtranslate/?src=userprofile)
  - La API de ScaleMT había dejado de funcionar. Ahora se usa APY.
* [mozCleaner](https://addons.mozilla.org/es/firefox/addon/mozcleaner/?src=userprofile)
  - Errores de escritura
* [The Super Clock](https://addons.mozilla.org/es/firefox/addon/the-super-clock/?src=userprofile)
  - Pequeño fallo que hacía que horas con un cero delante no ocupasen lo mismo que las demás. Por ejemplo, 21:04 era representado como 21:4.
* [Google+ Share](https://addons.mozilla.org/es/firefox/addon/google-share/?src=userprofile)
  - Arreglar un fallo molesto que hacía que desapareciese el icono en algunas ventanas. Gracias a ismirth por decírmelo. Se actualizó a Australis.
  - Traducción de Google+ Share a diversos idiomas
  - Gestión analítica
* [No más 900](https://addons.mozilla.org/es/firefox/addon/no-m%C3%A1s-900/?src=userprofile)
  - Nuevo complemento
* [Google+ Share for Android](https://addons.mozilla.org/es/firefox/addon/google-share-android/?src=userprofile)
  - Actualizar rutas a los módulos de Addon SDK
  - No interrumpir en las selecciones de texto. Se ha cambiado el lugar donde aparece el botón para no quitar la opción de seleccionar texto de Firefox.
* [Google AdSense Earnings](https://addons.mozilla.org/es/firefox/addon/google-adsense-earnings/?src=userprofile)
  - Nuevo complemento
  - Módulo en npm de identificación con Google via OAuth2
* [Bc.vc shortener](https://addons.mozilla.org/es/firefox/addon/bcvc-shortener/?src=userprofile)
  - Nuevo complemento
* [DivHTTP](https://addons.mozilla.org/es/firefox/addon/divhttp/?src=userprofile)
  - Traducciones
  - Ahora viene con su propia copia de httpd.js, puesto que ha sido retirado de Firefox
* [Divel Notepad](https://addons.mozilla.org/es/firefox/addon/divel-notepad/?src=userprofile)
  - Traducciones

El objetivo con esto es elevar la calificación que tengo en AMO por encima de las 3 estrellas sobre 5 actuales que tengo. He recibido malas críticas en algunos de estos complementos que me gustaría intentar remediar.
