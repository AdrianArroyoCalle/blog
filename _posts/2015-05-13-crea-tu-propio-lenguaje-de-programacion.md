---
layout: post
title: Crea tu propio lenguaje de programación
description: Aprende a crear tu propio lenguaje de programación con máquina virtual
keywords:
 - perin
 - rust
 - programacion
 - blogstack
 - linux
 - maquinavirtual
 - lenguajes
---

> Esta entrada la escribí en [DesdeLinux](http://blog.desdelinux.net/crea-tu-propio-lenguaje-de-programacion/) hace ya un tiempo y la quiero conservar aquí. La entrada no es la original sino que la he modificado para que siga vigente - __MAYO DE 2015__

![Lenguajes de programación]({{ site.baseurl}}images/LenguajesProgramacion.jpg)

Después de escribir el primer artículo sobre cómo crear tu propio sistema operativo, alguien me dijo que si podía hacer un artículo sobre cómo crear un lenguaje de programación. Al principio no hice mucho caso, pero ahora y por otros caminos he aprendido bastante más sobre la creación de los lenguajes de programación. Así pues, vamos a hacer un lenguaje de programación básico, fácilmente empotrable en otros programas y que funcione con una máquina virtual que también diseñaremos. Hoy nos toca hacer la máquina virtual más básica.

Probablemente te preguntes: “¿una máquina virtual? ¿Pero eso no es muy difícil y además ralentiza los programas?” Al contrario, una máquina virtual simple es muy sencilla y relativamente rápida. He elegido Rust como lenguaje para la máquina virtual. Pero, ¿qué es [Rust](http://rust-lang.org)?

> [Rust](http://rust-lang.org) es un lenguaje de programación que está enfocado en la seguridad en las ejecuciones, así que utilizándolo será prácticamente imposible que alguien consiga cerrar la máquina virtual. Es un lenguaje compilado en desarrollo creado por Mozilla. Servo, el sustituto de Gecko, se está desarrollando en él. Todavía puede cambiar su sintaxis pero el código que voy a usar va a mantenerse hasta la primera versión estable.

Rust se instala en Linux de manera sencilla. Antes se podía usar un PPA pero ahora el script de RustUp es muy bueno y se encarga de todo.

```sh
curl -s https://static.rust-lang.org/rustup.sh | sudo sh
```

###¿Cómo funciona una máquina virtual?

Si sabes como funciona el mundo en ensamblador es exactamente igual, con el stack o la pila. Si no, te lo explico. Imaginémonos el siguiente código:

```
print 2+3
```

El ordenador no entiende lo que significa 2+3, ni tampoco sabe qué orden hay que seguir. Los ordenadores funcionan con pilas o stacks en los que se van acumulando datos y se van sacando continuamente. Ese código en nuestra máquina virtual debería ser algo parecido a esto:

```
PUSH 2
PUSH 3
ADD
PRINT
```

Básicamente, pondríamos el 2 en la pila en lo alto, el 3 también. ADD sacaría (es decir, lo elimina de la pila y obtiene su valor) los 2 últimos elementos de la pila y añadiría el resultado en lo alto de la pila. PRINT cogería el último elemento de la pila y lo usaría para mostrárnoslo. Ahora hagamos eso en Rust.

> Ahora es cuando deberías descargarte el código fuente que está en GitHub. Voy a empezar por el archivo _vm.rs_

Primeramente deberemos definir un lenguaje para el Bytecode, podríamos usar uno ya existente como el de Java o el CLR de .NET/Mono, pero vamos a crear nosotros uno más básico.

Usamos notación hexadecimal para cada instrucción. Para hacer la traducción entre el código hexadecimal y la instrucción voy a usar la librería (crate en el argot de Rust) de enum_primitive. Antes se podía usar #[derive(FromPrimitive)] pero en Rust 1.0 no está disponible.

Ahora debemos hacer una función que ejecute cada una de esas instrucciones. Para ello debemos leer un byte y compararlo con las instrucciones que tenemos en la enumeración. Si se encuentra alguna que exista se debe ejecutar su acción.

Eso hacemos para leer cada byte individualmente y para ejecutarlas:

Como ven, diferenciamos si antes se nos dio la orden de PUSH (nuestra orden INTEGER), el siguiente byte será llevado completamente a la pila. Ahí estamos usando dos funciones que no les he enseñado, self.pop() y self.push(), que se encargan obviamente de manejar el stack.

No son muy complejas, pero la función de pop tiene mecanismos de detección de errores. De hecho, en Rust, si quitásemos esos mecanismos nos daría un error de compilación. Ahora simplemente debemos llamar en un programa a Perin (nuestra máquina virtual) y que ejecute un bytecode.

Ese bytecode puede ser leído de un fichero, pero aquí para simplificar lo he almacenado en una variable. Si lo ejecutamos nos dará el resultado esperado:

```
Perin v0.1
Perin VM executes FlopFlip bytecode
Starting PerinVM instance
PerinVM v0.1.0
Integer value 5
```

Todo el código está disponible en GitHub bajo la Apache License 2.0: https://github.com/AdrianArroyoCalle/perin. Para compilar deben tener Cargo instalado y poner:

```
cargo run
```