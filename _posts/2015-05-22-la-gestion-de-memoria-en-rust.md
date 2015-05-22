---
layout: post
title: La gestión de la memoria en Rust
description: Aprendiendo a usar valores en stack y heap con los conceptos de dueños, mebresía, referencias, punteros y derreferencias.
keywords:
 - blogstack
 - rust
 - linux
 - ubuntu
 - cpp
 - cplusplus
 - memoria
---

Finalmente [ha sido publicada la versión 1.0 de Rust](http://blog.rust-lang.org/2015/05/15/Rust-1.0.html). El lenguaje diseñado por Mozilla basado en 3 principios:

* Seguridad
* Concurrencia
* Rendimiento

Hoy voy a hablar del primer principio, la razón principal para querer ser un sustituto de C++. Porque C++ está bien, pero puedes liarla mucho si no sabes lo que haces.

![Rust]({{ site.baseurl }}images/Rust.jpg)

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

Veamos ahora un código más complejo

{% highlight rust %}

struct Config{
	debug_mode: bool
}

struct App{
	config: Config
}

fn main(){
	let config=Config{debug_mode: true};
	
	let app=App{config: config};
	
	println!("OK");
}

{% endhighlight %}

Por supuesto el código compila pero este de aquí abajo no y solo he cambiado una línea.

{% highlight rust %}
struct Config{
	debug_mode: bool
}

struct App{
	config: Config
}

fn main(){
	let config=Config{debug_mode: true};
	
	let app=App{config: config};
	let backup=App{config: config}; // He añadido esta línea
	
	println!("OK");
}

{% endhighlight %}

La razón es que cuando creamos la estructura de App por primera vez le pasamos la membresía de config a la estructura app. Así la función main no le puede pasar la membresía a backup porque ya se la pasó a app. 

## Referencias

Para solucionar este problema Rust usa las referencias. Así el dueño de config seguirá siendo main() pero lo podrán usar las estructuras app y backup. Para usar referencias usamos el símbolo __&__.

{% highlight rust %}
struct Config{
	debug_mode: bool
}

struct App{
	config: &Config
}

fn main(){
	let config=Config{debug_mode: true};
	
	let app=App{config: &config};
	let backup=App{config: &config};
	
	println!("OK");
}

{% endhighlight %}

La estrucura ahora acepta &Config en vez de Config. Es de decir usa una referencia en vez de un valor. Sin embargo esto no compilará. El compilador normalmente deduce si es posible hacer una referencia a algo no existente, un fallo común en C++. En caso de tener dudas no compilará. Rust es bastante inteligente pero no es mágico. En el caso de la estructura App, es necesario indicar que la propiedad config vivirá el mismo tiempo que la estructura.

{% highlight rust %}
struct Config{
	debug_mode: bool
}

struct App<'a>{
	config: &'a Config
}

fn main(){
	let config=Config{debug_mode: true};

	let app=App{config: &config};
	let backup=App{config: &config};
	println!("OK");
}
{% endhighlight %}

He usado la anotación de tiempo llamada __a__. Puedes poner cualquier nombre pero __a__ es muy corto.

## Implementaciones y referencias

Voy a introducir un concepto de Rust que son las implementaciones. Para haceros una idea rápida, serían como clases de C++, pero solo alojan funciones.

{% highlight rust %}
impl<'a> App<'a>{
	fn isDebugMode(&self) -> (){
		println!("DEBUG MODE: {}",self.config.debug_mode);
	}
	
	fn delete(self) -> (){
		
	}
}
{% endhighlight %}

He creado dos funciones para implementar App. Son idénticas salvo por un pequeño detalle, una toma el valor self (como this en C++) por referencia y la otra toma el valor directamente.
{% highlight rust %}
	let app=App{config: &config};
	app.isDebugMode();
	app.delete();
{% endhighlight %}

Compila y funciona. Cambiemos el orden.
{% highlight rust %}
	let app=App{config: &config};
    app.delete();
    app.isDebugMode();
{% endhighlight %}
Ya no compila. La razón es que cuando llamamos a delete() estamos pasandole la membresía de app entera. Ahora delete() es la dueña de app y cuando salimos de la función eliminamos app porque si su dueña ha muerto, app también debe morir (no es tan sangriento como pensais). Rust lo detecta y delete() será la última función que podemos llamar de app. Por cierto si os preguntais como funcionan las implementaciones en Rust (que no son clases), este código haría lo mismo llamando a funciones estáticas. Quizá así veais mejor como se pasa el concepto de dueños y membresía.
{% highlight rust %}
	let app=App{config: &Config};
    App::isDebugMode(&app);
    App::delete(app);
{% endhighlight %}
## Diversión con punteros en el heap

Todo estas variables eran del stack que siempre es la manera más sencilla de operar. Vamos ahora a ver como funcionaría esto con punteros. Los punteros operan como variables en el stack que hacen referencia a partes de la memoria que están en el heap. En Rust podemos operar con punteros con máxima seguridad pues todo lo aplicable a variables en el stack sigue siendo válido. Solo hay un dueño y podemos hacer referencias, aunque quizá necesitemos marcar el tiempo de vida manualmente.
{% highlight rust %}
	let puntero: Box<i32>=Box::new(42);
{% endhighlight %}
Ahora el valor 42 estará en el heap y con puntero podremos acceder a él. Sin embargo como es lógico, no podemos operar directamente con él.
{% highlight rust %}
	puntero+1 //No funciona
{% endhighlight %}
Para operar el valor directamente tenemos que derreferenciarlo. Se usa __*__
{% highlight rust %}
	*puntero+1 // Sí funciona, y será 43
{% endhighlight %}
Así que esta operación sería correcto. Nótese el uso de __mut__ para permitir editar el valor. En Rust por defecto las variables no son mutables. Ese privilegio tiene que ser declarado por adelantado.
{% highlight rust %}
	let mut puntero: Box<i32>=Box::new(41);
    *puntero+=1;
  	println!("La respuesta es: {}",*puntero);
{% endhighlight %}
Como curiosidad mencionar que la macro println! (en Rust si algo termina con __!__ es una macro) acepta puntero o *puntero indistintamente ya que se da cuenta si es necesario derreferenciar o no.

## El problema final

¿Qué pasaría si copiamos un puntero en otro? Pues como un valor en el heap solo puede tener un dueño, la membresía será del último puntero.

{% highlight rust %}
	let mut puntero: Box<i32>=Box::new(41);
    *puntero+=1;
    let puntero_inmutable=puntero;
    println!("La respuesta es: {}",puntero); // Esta línea no compilará pues el acceso a la respuesta última del universo ahora es propiedad de puntero_inmutable
    println!("La respuesta, ahora sí, es: {}",puntero_inmutable);
{% endhighlight %}
Como curiosidad, este es un curioso método para bloquear en un determinado momento el acceso de escritura a nuestro puntero aunque es fácil volver a obtener el acceso a escritura con un nuevo cambio de dueño.

## Conclusiones

Podemos ver que es un lenguaje que presta mucha atención a la seguridad. C++ es mucho más liberal en ese sentido y Mozilla cree que es un problema a la hora de desarrollar grandes aplicaciones. ¿Qué te ha parecido? Si tienes alguna duda no titubees y pregunta.