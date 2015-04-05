---
layout: post
title: La información es poder
description: Los motivos que me llevan a hacer un servicio de analíticas propio
keywords:
 - blogstack
 - analiticas
 - estadistica
 - node.js
 - javascript
 - openshift
---

La información es poder. La frase suele atribuirse a Francis Bacon y creo que en estos tiempos cada vez se vuelve más cierta. Términos como Big Data, políticas de privacidad y similares son términos para hablar del gran poder que nos ofrece la información, si la sabemos interpretar y usar en consecuencia.

## Obteniendo la información

Esto venía para explicar que finalmente y después de pensarlo un rato he decidido crear mi propio sistema de analíticas para Secta Sectarium. Las analíticas pueden ofrecerme valiosa información pero no encontré ningún servicio que me gustase. Muchos sistemas de analíticas están centrados en blogs (como [Google Analytics](http://google.com/analytics) o [New Relic Browser](http://newrelic.com)) o en aplicaciones móviles (Google Analytics, [Flurry](https://developer.yahoo.com/analytics/)). ¿Había algún servicio dedicado solo a juegos? Sí, [GameAnalytics](http://www.gameanalytics.com/) es específico pero no tiene API para HTML5 (y las APIs REST no se pueden llamar entre dominios en HTML5, CORS se llama la idea). Google Analytics se puede modificar lo suficiente para funcionar pero ya que tenía que trabajarmelo he preferido crear mi propia solución.

![La gente se inventa estadísticas con tal de demostrar algo y eso lo sabe el 14% de la gente]({{ site.baseurl }}images/LaGenteSeInventaEstadisticas.jpg)

## Fliuva

Así que he decidido gastar una gear de [OpenShift](http://openshift.com) para una aplicación Node.js 0.12 y MySQL 5.5. Entre SQL y NoSQL he elegido SQL porque para introducir datos de eventos que luego, posteriormente, van a ser tratados, SQL da un mejor rendimiento y el esquema de tabla es más común. Las analíticas las podré ver desde la propia aplicación, que usa [Vis.js](http://visjs.org) para la visualización.

![La persona más poderosa después de una fiesta es la que tomó las fotos]({{ site.baseurl }}images/LaPersonaMasPoderosa.jpg)

En próximas entradas veremos como se puede crear Fliuva y que métricas son más importantes.