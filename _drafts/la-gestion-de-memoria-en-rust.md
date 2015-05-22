---
layout: post
title: La gestión de la memoria en Rust

---

Finalmente ENLACE ha sido publicada la versión 1.0 de Rust. El lenguaje diseñado por Mozilla basado en 3 principios:

* Seguridad
* Concurrencia
* Rendimiento

Hoy voy a hablar del primer principio, la razón principal para querer ser un sustituto de C++. Porque C++ está bien, pero puedes liarla mucho si no sabes lo que haces.

## El concepto de dueño

En Rust todo tiene un dueño. No puede haber más de uno ni ninguno, debe ser uno exactamente.

{% highlight rust %}
fn main(){
	let A = 5;
    // El dueño de A es main()

}

{% endhighlight %}

Hasta aquí todo es sencillo. Ahora pasaremos la variable A a otra función.

{% highlight rust %}

fn sumar(a: i32, b: i32) -> i32{
	a+b
}
fn main(){
	let A = 5;
	let suma = sumar(A,4);
	println!("{}",suma);
}

{% endhighlight %}

El  programa compila y nos da el resultado, que es 9. En los lenguajes de bajo nivel las variables pueden usar memoria del stack o del heap. Un pequeño repaso sobre sus diferencias.

###### Stack

* Se reserva su espacio en RAM cuando el programa arranca
* Son más rápidas de acceder
* No se les puede cambiar el tamaño
* Son más seguras

###### Heap

* Se debe reservar manualmente la RAM cuando queramos
* Son más lentas de acceder
* Pueden cambiar su tamaño en tiempo real
* Son menos seguras. Pueden dar lugar a fugas de memoria.

En este último caso, la variable A cuyo dueño es main() le pasa la membresía temporalmente a sumar(). La membresía se devuelve a main() rápidamente y esta garantizado que así suceda. El compilador lo permite. Veamos ahora un ejemplo más complejo.
