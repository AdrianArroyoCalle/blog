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

Hasta aquí todo es sencillo. Ahora pasaremos la variable A a otra función