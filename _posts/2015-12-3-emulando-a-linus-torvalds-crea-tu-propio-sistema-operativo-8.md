---
layout: post
title: "Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (VIII)"
description: Octava parte de la serie tutorial para crear nuestro sistema operativo. Hoy revisamos la entrada del teclado.
keywords:
 - linux
 - desdelinux
 - programacion
 - blogstack
 - sistemas-operativos
 - next-divel
 - kernel
 - x86
 - keymap
 - teclado
---

> _Este artículo lo escribí para el blog en español [DesdeLinux](http://blog.desdelinux.net) el 23 de diciembre de 2014 y ahora lo dejo aquí, en mi blog personal. El artículo está tal cual, sin ninguna modificación desde aquella fecha._

Volvemos a la serie de tutoriales sobre como crear nuestro propio sistema operativo. Supongo que este capítulo os gustará mucho porque por fin podremos interactuar con nuestro sistema operativo. Hoy leeremos la entrada del teclado. Para ello el esquema es similar al del timer. Tenemos que usar los IRQ igualmente así que empezaremos igual que con el timer.

{% highlight c %}

ND_IRQ_InstallHandler(1,&ND_Keyboard_Handler);
{% endhighlight %}

Nuestro handler de teclado sin embargo es algo más complejo ya que vamos leyendo las teclas y las vamos depositando en un buffer.

{% highlight c %}
extern "C"
void ND_Keyboard_Handler(struct regs* r)
{
    unsigned char scancode = ND::Keyboard::GetChar();
    if(scancode!=255)
    {
		ND::Screen::PutChar(scancode);
		stringBuffer[stringPos]=scancode;
		stringPos++;
    }
}
{% endhighlight %}

Podemos comprobar como llamamos a una función llamada ND::Keyboard::GetChar. Allí obtenemos el caracter y después si no es un caracter vacío (aquí he usado 255, habría que usar un sistema mejor) ponemos el caracter en pantalla y lo almacenamos en un buffer simple de chars (esto también es susceptible de mejora, el sistema actual puede desbordarse).

{% highlight c %}
unsigned char ND::Keyboard::GetChar()
{
	unsigned char scancode;
	scancode=(unsigned char)ND::Ports::InputB(0x60);
	if(scancode & ND_KEYBOARD_KEY_RELEASE)
	{
		return 255;
	}else{
		return en_US[scancode];
	}
}
 
char* ND::Keyboard::GetString()
{
	while(stringBuffer[stringPos-1]!='\n')
	{
	}
	stringPos=0;
	return stringBuffer;
}
{% endhighlight %}

Aquí podemos ver como se obtiene la tecla que ha sido pulsada. En 0x60 siempre va a estar la última tecla pulsada. De hecho se puede leer directamente sin tener que usar el IRQ, pero entonces no sabremos indentificar cuando se ha producido un cambio. Allí comprobamos con la operación AND que el código de obtuvimos corresponde a una tecla que se ha dejado de pulsar.

En ese caso devolvemos 255 (porque luego lo ignoraremos) y en caso contrario la tecla ha sido pulsada. En ese caso devolvemos la posición de un array llamado en_US. ¿Qué información contiene este array? Este array es lo que llamaríamos un keymap o un mapa de caracteres. Como sabrán diferentes idiomas tienen diferentes teclados y no son compatibles ya que sobreescriben las teclas. Así en_US nos dará la tecla correspondiente a cada código y funcionará en un teclado americano.

{% highlight c %}
unsigned char en_US[128]=
{
	0,27,'1','2','3','4','5','6','7','8','9','0','-','=', '\b',
	'\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',
	0, /* Ctrl */
	'a','s','d','f','g','h','j','k','l',';',
	'\'','`',0, /* Left Shift */
	'\\','z','x','c','v','b','n','m',',','.','/', 0,/* Right shift */
	'*', 0, /* Alt */
	' ',
	0, /* Caps lock*/
	0,0,0,0,0,0,0,0,0,0, /* F1-F10 keys */
	0, /* Num lock */
	0, /* Scroll lock */
	0, /* Home key */
	0, /* Up arrow */
	0, /* Page up */
	'-',
	0, /* Left arrow */
	0,
	0, /* Right arrow */
	'+',
	0, /* End key */
	0, /* Down arrow */
	0, /* Page down */
	0, /* Insert key */
	0, /* Delete key */
	0,0,0,
	0, 0, /* F11-F12 Keys */
	0
};
{% endhighlight %}

También había una función definida que obtenía una frase. El propósito es simplemente obtener acceso más fácilmente a los strings desde las aplicaciones que lo necesiten, de momento solo una. Hablo de NextShellLite, una versión reducida del posible futuro shell que tendría NextDivel. El propósito de NextShellLite es únicamente el de proveer de un shell reducido para ir probando poco a poco nuevas funcionalidades. No voy a poner el código del shell aquí pero lo he incluido dentro del código de NextDivel.

De momento no funciona como un programa aparte sino como una función que llama el kernel, principalmente porque todavía no añadimos la opción de ejecutar ejecutables. Y claro, unas imágenes de como funciona el shell con las nuevas funciones de entrada de teclado.

![NextShellLite]({{ site.baseurl }}images/NextShellLite.png)