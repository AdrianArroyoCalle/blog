---
layout: post
title: Rust Essentials, reseña del libro
description: Reseña del libro Rust Essentials. Un libro para introducirse de manera sencilla en Rust.
keywords:
 - rust
 - linux
 - ubuntu
 - blogstack
 - reseña
 - libros
---

> Dicen que a las personas importantes les pide la gente su opinión. Así que no entiendo porque tengo ahora que dar opiniones...

Hoy voy a hablar del libro [Rust Essentials](https://www.packtpub.com/application-development/rust-essentials) de [Ivo Balbaert](https://www.linkedin.com/pub/ivo-balbaert/0/9b3/949). En primer lugar quiero agradecer a la editorial [Packt Publishing](https://www.packtpub.com) por haber contado conmigo a la hora de valorar este libro para que todos vosotros conozcais algo más acerca de él.

![Rust Essentials]({{ site.baseurl }}images/RustEssentials.jpg)

Rust Essentials es un libro de introducción al lenguaje de programación Rust, lenguaje del que ya he hablado [anteriormente]({% post_url 2015-05-22-la-gestion-de-memoria-en-rust %}). El libro está en inglés y asume que no conoces nada o muy poquito de Rust pero sí que has programado con anterioridad. Así pues, el libro no explica conceptos de programación tales como funciones o variables sino que directamente expone sus peculiaridades. Es recomendable haber programado C para entender algunas partes del libro al 100%.

El libro se estructura en 9 capítulos, a saber:

* Starting with Rust
* Using variables and types
* Using functions and control structures
* Structuring data and matching patterns
* Generalizing code with high-order functions and parametrization
* Pointers and memory safety
* Organizing code and macros
* Concurrency and parallelism
* Programming at the boundaries

En estos temas se tratan desde cosas tan triviales como los comentarios (que no lo son, pues según explica el libro, puedes hacer comentarios de RustDoc, que serán compilados como documentación en HTML y tienen marcado Markdown) hasta la gestión multihilo de Rust, para aprovechar uno de los 3 apartados en los que se enfoca Rust: la concurrencia.

Veremos la magia de Rust, respetando la convención de estilo (esto es importante, no vaya a pasar como con JavaScript) y las características que hacen de Rust un gran lenguaje de programación. El libro contiene ejercicios e incluso analizarás porque en determinados lugares obtenemo un error de compilación.

> Hacen falta un tiempo para que dejes de ver al compilador de Rust como un protestón sin sentido y lo empieces a ver como tu mejor amigo en la programación

El libro también se adentra a explicar las partes de programación funcional de Rust, no sin antes explicar las closures y las funciones de primer orden. Más tarde nos adentramos en las traits, que posibilitan la programación orientada a objetos pero no como se plantea desde C++, C# o Java. En Rust, es mucho más flexible y unido a las funciones genéricas podemos evitar la repetición del código en un 100%. __DRY__ (don't repeat yourself). El capítulo 6 es interesante y quizá algo denso para alguien que venga de lenguajes donde la gestión de memoria es administrada por una máquina virtual o intérprete. No es difícil, pero hay que saber las diferencias. Rust tiene muchos tipos de punteros y he de decir que este libro los explica mejor que mi antiguo libro de C de Anaya.

![Rust]({{ site.baseurl }}images/Rust.jpg)

Más tarde se ve el sistema de módulos y la creación de macros en Rust. Las macros en Rust son muy potentes, más que en C donde también son bastante usadas. El capítulo 8 se dedica por completo a los hilos y la gestión de datos entre distintos hilos. El capítulo 9 nos explica cosas interesantes pero que no tienen mucha densidad y no se merecen un capítulo propio como la intercomunicación entre C y Rust o instrucciones en ensamblador directamente en el código.

__Me gusta__ que tenga ejercicios para practicar (las soluciones están en GitHub), que use las herramientas disponibles de Cargo, que explique porque un determinado código no compilará, que hable de como desarrollar tests unitarios y de que explore todas las características del lenguaje de manera incremental, muchas veces modificando ejemplos anteriores.

__No me gusta__ que quizá sea un libro muy rápido que presupone algunos conceptos y que casi no explora la librería estándar mas que para hablar de ciertas traits muy útiles y la gestión de hilos. No habla en ningún momento de como leer archivos por ejemplo aunque en el anexo menciona librerías para leer distintos tipos de archivos.

__En definitiva__ es un libro que recomiendo a todos aquellos que ya tengan experiencia programando y quieran aprender un nuevo lenguaje, lleno de peculiaridades diseñadas para trabajar en: velocidad, seguridad y concurrencia. No se lo recomendaría a alguien que no hubiese programado nunca.