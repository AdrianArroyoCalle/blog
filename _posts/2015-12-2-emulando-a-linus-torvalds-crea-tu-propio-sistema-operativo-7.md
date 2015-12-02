---
layout: post
title: "Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (VII)"
description: Séptima parte de la serie tutorial para crear nuestro sistema operativo. Hoy creamos un timer, usando los IRQ.
keywords:
 - linux
 - desdelinux
 - programacion
 - blogstack
 - sistemas-operativos
 - next-divel
 - kernel
 - x86
 - timer
---

> _Este artículo lo escribí para el blog en español [DesdeLinux](http://blog.desdelinux.net) el 25 de agosto de 2014 y ahora lo dejo aquí, en mi blog personal. El artículo está tal cual, sin ninguna modificación desde aquella fecha._

Bienvenidos a otro post sobre cómo crear nuestro propio sistema operativo. Ha pasado mucho tiempo desde el último post, debido principalmente a un bug que encontré en lo que nos toca hoy. Veremos cómo manejar el reloj en arquitecturas x86.

Anteriormente habíamos activado los IRQ de manera genérica, pero hubo un pequeño problema ya que no los activábamos correctamente y pasábamos datos extra. Finalmente lo solucionamos __carlosorta__ y yo y os puedo seguir comentando cómo seguir.

Bien, el reloj es un IRQ, concretamente el primero. Para configurarlo usaremos la función que definimos anteriormente para instalar de manera genérica los IRQ, la ND_IRQ_InstallHandler.

{% highlight c %}

int ND_TIMER_TICKS=0;

void ND::Timer::Phase(int hz)
{
	int divisor=1193180/hz;
	ND::Ports::OutputB(0x43,0x36);
	ND::Ports::OutputB(0x40, divisor & 0xFF);
	ND::Ports::OutputB(0x40, divisor >> 8);
}
void ND::Timer::Wait(int ticks)
{
	unsigned long eticks;
	eticks=ND_TIMER_TICKS+ticks;
	while(ND_TIMER_TICKS < eticks)
	{
		
	}
}
void ND::Timer::Setup()
{
	ND::Screen::SetColor(ND_SIDE_FOREGROUND, ND_COLOR_BLACK);
	ND::Screen::PutString("\nSetup timer...");
	
	ND_IRQ_InstallHandler(0,&ND_Timer_Handler);
	
	ND::Screen::SetColor(ND_SIDE_FOREGROUND,ND_COLOR_GREEN);
	ND::Screen::PutString("done");
}
extern "C"
void ND_Timer_Handler(struct regs* r)
{
	ND_TIMER_TICKS++;
	if(ND_TIMER_TICKS % 18 ==0)
	{
		ND::Screen::SetColor(ND_SIDE_FOREGROUND,ND_COLOR_BROWN);
		ND::Screen::PutString("\nOne more second"); WE SHOULD DO A REFRESH SCREEN
	}
}

{% endhighlight %}

El código se ejecuta de la siguiente manera: el sistema de inicialización llama a __ND::Timer::Setup__, que llama a __ND_IRQ_InstallHandler__ para insertar en la primera posición, el IRQ0, una función de callback cuando el evento se produzca, esa es __ND_Timer_Handler__ que aumenta los ticks. Como hemos puesto la velocidad del reloj a 18 Hz, como veremos más adelante, si lo dividiésemos entre 18 y nos diese entero habría pasado un segundo.

La función __ND::Timer::Phase__ nos sirve para ajustar la velocidad del timer, ese número tan extravagante es 1.19 MHz que es un valor común. Bien, esta función la deberemos llamar si quisiésemos cambiar la velocidad del timer, por defecto va a 18,22 Hz, un valor peculiar que debió de decidir alguien dentro de [IBM](http://ibm.com) y se ha quedado hasta nuestros días.

La función __ND::Timer::Wait__ es bastante simple, solamente espera con un bucle _while_ hasta que se hayan alcanzado los _ticks_ necesarios para continuar.

En la imagen podemos comprobar que si descomentamos el código dentro del ND_Timer_Handler obtenemos esto:

![NextDivel Segundos]({{ site.baseurl }}images/NextDivelSegundos.png)