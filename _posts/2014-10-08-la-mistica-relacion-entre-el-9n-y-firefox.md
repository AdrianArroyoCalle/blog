---
layout: post
title: La mística relación entre el 9N y Firefox
keywords:
 - firefox
 - mozilla
 - blogstack
 - cataluña
 - addons
 - el-tiempo-en-españa
 - complot
 - bug
 - politica
description: ¿Cómo alguien puede relacionar un bug con un complot político?
---
Si habeis leído el título pudiera parecer que he empezado a tomar drogas o alguna sustancia estupefaciente variada. Sin embargo nada más lejos de la realidad, la mística relación entre el 9N (la consulta catalana) y [Firefox](http://getfirefox.com) se abrió ante mis ojos cuando vi esta valoración de mi complemento en el sitio de complementos de Firefox
![Cataluña y Firefox - Es un complot]({{ site.baseurl }}images/9N-Firefox.png)

> He intentado por tres golpes instalar este complemento, pero, como ya es fuerza normal, si no eres de MADRID ("Villa y Corte") no funciona. Puedes entrar a "Opciones", pero el identificador de municipio NO ADMITE un primer número que sea el "0". Por lo tanto, Barcelona, que es id 08019 , no funciona. SIEMPRE IGUAL. 9N. _(Traducción hecha por [Apertium](http://www.apertium.org))_

Os pongo en situación. El comentario en cuestión se refiere al complemento [El Tiempo en España](https://addons.mozilla.org/es/firefox/addon/el-tiempo-de-espa%C3%B1a/) y la vloración anterior (solo había una antes) le daba 5 estrellas sobre 5. ¿Qué ha pasado? Resulta que cuando hice el complemento (es bastante viejo) use el control numérico que ofrece [XUL](https://developer.mozilla.org/es/docs/XUL) y almacené la preferencia como un entero. Esto funcionaba con todos los códigos que había probado pero fallaba con los que empezaban con 0. ¿Por qué? La respuesta es muy sencilla y es que al estar en un control numérico al introducir un número a la izquierda este se nos quita tan rápidamente como introdujamos la siguiente cifra. El código de Barcelona empieza por 0 y claro, en esa ciudad no funcionaba el complemento. En eso le doy la razón al autor de la valoración. Pero de ahí a relacionar el que no funcione con un compot contra los catalanes por parte de Madrid me parece excesivo y un sin sentido. ¿Cómo alguien puede relacionar un bug con un complot político? (encima de un complemento que es open source)
