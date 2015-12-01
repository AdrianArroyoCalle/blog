---
layout: post
title: "Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (V)"
description: Quinta parte de la serie tutorial para crear nuestro sistema operativo. Hoy revisamos la Interruption Descriptor Table (o IDT).
keywords:
 - linux
 - desdelinux
 - programacion
 - blogstack
 - sistemas-operativos
 - next-divel
 - kernel
 - idt
 - x86
 - exception
---

> _Este artículo lo escribí para el blog en español [DesdeLinux](http://blog.desdelinux.net) el 11 de enero de 2014 y ahora lo dejo aquí, en mi blog personal. El artículo está tal cual, sin ninguna modificación desde aquella fecha._

En esta quinta entrega veremos una tabla bastante parecida a la GDT tanto en teoría como en uso, nos referimos a la __IDT__. Las siglas de IDT hacen referencia a _Interrupts Description Table_ y es una tabla que se usa para manejar las interrupciones que se produzcan. Por ejemplo, alguien hace una división entre 0, se llama a la función encargada de procesar. Estas funciones son los ISR (_Interrupt Service Routines_). Así pues vamos a crear la IDT y añadir algunos ISR.

Lo primero vamos a declarar las estructuras correspondientes a la IDT:

{% highlight c %}

struct Entry{
    uint16_t base_low;
    uint16_t sel;
    uint8_t always0;
    uint8_t flags;
    uint16_t base_high;
} __attribute__((packed));

struct Ptr{
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

{% endhighlight %}

Como se observa si comparáis con la GDT la estructura Ptr es idéntica y la Entry es bastante parecida. Por consiguiente las funciones de poner una entrada (SetGate) e instalar (Install) son muy parecidas.

{% highlight c %}
void ND::IDT::SetGate(uint8_t num,uint32_t base,uint16_t sel, uint8_t flags)
{
	idt[num].base_low=(base & 0xFFFF);
	idt[num].base_high=(base >> 16) & 0xFFFF;
	idt[num].sel=sel;
	idt[num].always0=0;
	idt[num].flags=flags;
}
{% endhighlight %}

Instalar:

{% highlight c %}
idtptr.limit=(sizeof(struct ND::IDT::Entry)*256)-1;
idtptr.base=(uint32_t)&idt;
ND::Memory::Set(&idt,0,sizeof(struct ND::IDT::Entry)*256);
ND::IDT::Flush();
{% endhighlight %}

Si nos fijamos veremos que la función de instalar usa la función ND::Memory::Set que habíamos declarado en el otro post. También podemos apreciar como no hacemos ninguna llamada a SetGate todavía y llamamos a ND::IDT::Flush, para esta función usamos otra vez la sentencia asm volatile:

{% highlight c %}
asm volatile("lidtl (idtptr)");
{% endhighlight %}

Si todo va bien y hacemos un arreglo estético debería quedar así:

![NextDivel IDT]({{ site.baseurl }}images/NextDivel-IDT.png)

Bien, ahora vamos a empezar a rellenar la IDT con interrupciones. Aquí voy a crear solo una pero para el resto se haría igual. Voy a hacer la interrupción de división por cero. Como bien sabrán en matemáticas no se puede dividir un número entre 0. Si esto ocurre en el procesador se genera una excepción ya que no puede continuar. En la IDT la primera interrupción en la lista (0) corresponde a este suceso.

Añadimos esto entre el seteo de memoria y el flush dentro de la función Install de la IDT:

{% highlight c %}
ND::IDT::SetGate(0,(unsigned)ND::ISR::ISR1,0x08,0x8E);
{% endhighlight %}

La función de callback va a ser ND::ISR::ISR1 que es bastante simple aunque debemos usar ASM:

{% highlight c %}
void ND::ISR::ISR1()
{
	asm volatile(
    "cli \n"
    "pushl 0 \n"
    "pushl 0 \n"
    "jmp ND_ISR_Common \n");
}
{% endhighlight %}

ND_ISR_Common lo definiremos como una función en lenguaje C. Para ahorrar ficheros y mejorar legibilidad podemos usar extern “C”{}:

{% highlight c %}
extern "C"

void ND_ISR_Common()
{
    asm volatile(
    "pusha \n"
    "push %ds \n"
    "push %es \n"
    "push %fs \n"
    "push %gs \n"
    "movw $0x10, %ax \n"
    "movw %ax, %ds \n"
    "movw %ax, %es \n"
    "movw %ax, %fs \n"
    "movw %ax, %gs \n"
    "movl %esp, %eax \n"
    "push %eax \n"
    "movl $ND_ISR_Handler, %eax \n"
    "call *%eax \n"
    "popl %eax \n"
    "popl %ds \n"
    "popl %es \n"
    "popl %fs \n"
    "popl %gs \n"
    "popa \n"
    "addl 8, %esp \n"
    "iret \n"
    );
}
{% endhighlight %}

Este código en ASM puede ser un poco difícil de entender pero esto es así porque vamos a declarar una estructura en C para acceder a los datos que genere la interrupción. Obviamente si no quisieras eso podrías llamar simplemente en ND::ISR::ISR1 al Kernel Panic o algo por el estilo. La estructura tiene una forma tal que así:

{% highlight c %}
struct regs{
	uint32_t ds;
	uint32_t edi, esi, ebp, esp, ebx, edx, ecx, eax;
	uint32_t int_no, err_code;
	uint32_t eip, cs, eflags, useresp, ss;
};
{% endhighlight %}

Y por último hacemos la función ND_ISR_Handler (también con link del C) en que mostramos un kernel panic y una pequeña descripción del error según el que tenemos en una lista de errores.

{% highlight c %}
extern "C"

void ND_ISR_Handler(struct regs *r)
{
	if(r->int_no < 32) {
    	ND::Panic::Show(exception_messages[r->int_no]);
		for(;;);
	}

}
{% endhighlight %}

Bien y con esto ya somos capaces de manejar esta interrupción. Con el resto de interrupciones pasaría parecido salvo que hay algunas que devuelven parámetros y usaríamos la estructura reg para obtenerlo. Sin embargo te preguntarás que como sabemos si funciona de verdad. Para probar si funciona vamos a introducir una sencilla línea después del ND::IDT::Install():

{% highlight c %}
int sum=10/0;
{% endhighlight %}

Si compilamos nos dará un warning y si tratamos de ejecutarlo nos saldrá una bonita pantalla:

![NextDivel ISR]({{ site.baseurl }}images/NextDivel-ISR.png)

Y con esto termina este post, creo que es uno de los más extensos pero bastante funcional.