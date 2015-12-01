---
layout: post
title: "Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (VI)"
description: Sexta parte de la serie tutorial para crear nuestro sistema operativo. Hoy revisamos los IRQ.
keywords:
 - linux
 - desdelinux
 - programacion
 - blogstack
 - sistemas-operativos
 - next-divel
 - kernel
 - isr
 - x86
 - exception
 - interrupt
---

Bien, después de un pequeño paréntesis seguimos con nuestra serie de tutoriales. Si retomamos el código anterior debemos de tener el ISR de la división por cero. Ahora debemos de rellenar el resto de las ISR para las que habíamos puesto mensaje (las 32 primeras). Bien ahora vamos a seguir programando interrupciones, vamos a hacer las IRQ también conocidas como Interrupts Requests. Estas IRQ se generan por los dispositivos de hardware tales como teclados, ratones, impresoras, etc. Inicialmente las primeras 8 IRQ se mapean automáticamente en las posiciones de la IDT del 8 al 15. Como hemos usado las 32 primeras para las excepciones ahora tenemos que remapearlas. Nosotros pondremos la IRQ desde la 32 hasta la 45. Para ello primero debemos remapear los los IRQ:

{% highlight c %}

void ND::IRQ::Remap(int pic1, int pic2)
{
    #define PIC1 0x20
    #define PIC2 0xA0
    #define ICW1 0x11
    #define ICW4 0x01
    /* send ICW1 */

    ND::Ports::OutputB(PIC1, ICW1);
    ND::Ports::OutputB(PIC2, ICW1);

    /* send ICW2 */

    ND::Ports::OutputB(PIC1 + 1, pic1); /* remap */
    ND::Ports::OutputB(PIC2 + 1, pic2); /* pics */

    /* send ICW3 */

    ND::Ports::OutputB(PIC1 + 1, 4); /* IRQ2 -> connection to slave */
    ND::Ports::OutputB(PIC2 + 1, 2);

    /* send ICW4 */

    ND::Ports::OutputB(PIC1 + 1, ICW4);
    ND::Ports::OutputB(PIC2 + 1, ICW4);

    /* disable all IRQs */

    ND::Ports::OutputB(PIC1 + 1, 0xFF);
}
{% endhighlight %}

Ahora creamos una función para instalar los IRQ:

{% highlight c %}
void ND::IRQ::Install()
{
    ND::Screen::SetColor(ND_SIDE_FOREGROUND,ND_COLOR_BLACK);
    ND::Screen::PutString("\nInstalling IRQ...");
    ND::IRQ::Remap(0x20,0x28);
    ND::IDT::SetGate(32,(unsigned)ND::IRQ::IRQ1,0x08,0x8E);
    ND::IDT::SetGate(33,(unsigned)ND::IRQ::IRQ2,0x08,0x8E);
    ND::IDT::SetGate(34,(unsigned)ND::IRQ::IRQ3,0x08,0x8E);
    ND::IDT::SetGate(35,(unsigned)ND::IRQ::IRQ4,0x08,0x8E);
    ND::IDT::SetGate(36,(unsigned)ND::IRQ::IRQ5,0x08,0x8E);
    ND::IDT::SetGate(37,(unsigned)ND::IRQ::IRQ6,0x08,0x8E);
    ND::IDT::SetGate(38,(unsigned)ND::IRQ::IRQ7,0x08,0x8E);
    ND::IDT::SetGate(39,(unsigned)ND::IRQ::IRQ8,0x08,0x8E);
    ND::IDT::SetGate(40,(unsigned)ND::IRQ::IRQ9,0x08,0x8E);
    ND::IDT::SetGate(41,(unsigned)ND::IRQ::IRQ10,0x08,0x8E);
    ND::IDT::SetGate(42,(unsigned)ND::IRQ::IRQ11,0x08,0x8E);
    ND::IDT::SetGate(43,(unsigned)ND::IRQ::IRQ12,0x08,0x8E);
    ND::IDT::SetGate(44,(unsigned)ND::IRQ::IRQ13,0x08,0x8E);
    ND::IDT::SetGate(45,(unsigned)ND::IRQ::IRQ14,0x08,0x8E);
    ND::IDT::SetGate(46,(unsigned)ND::IRQ::IRQ15,0x08,0x8E);
    ND::IDT::SetGate(47,(unsigned)ND::IRQ::IRQ16,0x08,0x8E);
    ND::Screen::SetColor(ND_SIDE_FOREGROUND,ND_COLOR_GREEN);
    ND::Screen::PutString("done");
    asm volatile("sti");
}
{% endhighlight %}

La sentencia de asm _sti_ nos activa los __IRQ__. Bien ahora vamos con algo similar a los ISR. Las funciones de un IRQ básico:

{% highlight c %}
void ND::IRQ::IRQ1()
{
	asm volatile(
	"cli \n"
	"pushl 0\n"
	"pushl 32\n"
	"jmp ND_IRQ_Common"
	);
}
{% endhighlight %}

Una parte común (igual que la de los ISR):

{% highlight c %}
extern "C"
void ND_IRQ_Common()
{
    asm volatile(
    "pusha \n"
    "push %ds\n"
    "push %es\n"
    "push %fs\n"
    "push %gs\n"
    "movw $0x10, %ax \n"
    "movw %ax, %ds \n"
    "movw %ax, %es \n"
    "movw %ax, %fs \n"
    "movw %ax, %gs \n"
    "movl %esp, %eax \n"
    "push %eax \n"
    "movl $ND_IRQ_Handler, %eax \n"
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

Y un handler básico:

{% highlight c %}
extern "C"
void ND_IRQ_Handler(struct regs* r)
{
	void (*handler)(struct regs *r);
	if(r->int_no >= 40)
	{
	ND::Ports::OutputB(0xA0,0x20);
	}
	ND::Ports::OutputB(0x20,0x20);
}
{% endhighlight %}

Con esto ya deberíamos tener activados los IRQ aunque todavía no hagan nada. En el siguiente capítulo veremos como obtener datos a partir de estos IRQ como el reloj o el teclado.

![NextDivel IRQ]({{ site.baseurl }}images/NextDivel-IRQ.png)

Y con esto termina el post de hoy. Como habeis podido comprobar ahora escribo menos regularmente debido a otros asuntos. Aun así seguiré hasta tener un sistema operativo más completo