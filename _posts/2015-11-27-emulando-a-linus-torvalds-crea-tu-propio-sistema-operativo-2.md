---
layout: post
title: "Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (II)"
description: Segunda parte de la serie tutorial para crear nuestro propio sistema operativo.
keywords:
 - linux
 - desdelinux
 - programacion
 - blogstack
 - sistemas-operativos
 - next-divel
 - kernel
 - c
 - vga
 - panic
 - colores
---

> _Este artículo lo escribí para el blog en español [DesdeLinux](http://blog.desdelinux.net) el 29 de diciembre de 2013 y ahora lo dejo aquí, en mi blog personal. El artículo está tal cual, sin ninguna modificación desde aquella fecha._

Bienvenidos a otro post sobre como crear nuestro propio sistema operativo, en este caso NextDivel.

Si retomamos el código del [primer post]({% post_url 2015-11-26-emulando-a-linus-torvalds-crea-tu-propio-sistema-operativo-1 %}) al final de todo nos debería haber salido algo como esto:

![NextDivel, primera imagen]({{ site.baseurl }}images/NextDivel-1.png)

Si esto es correcto podemos continuar. Voy a usar el sistema y la estructura que tengo en GitHub (http://github.com/AdrianArroyoCalle/next-divel) ya que es más cómodo para mí y para vosotros. Como se puede apreciar el texto es un texto básico, no resulta atractiv0. Puede parecer algo más del montón. Pero como dice el dicho, para gustos colores, y en nuestro sistema operativo habrá colores. Los primeros colores que vamos a poder poner van a ser los que definen las tarjetas VGA y son 16:

1. Negro
2. Azul
3. Verde
4. Cyan
5. Rojo
6. Magenta
7. Marrón
8. Gris claro
9. Gris oscuro
10. Azul claro
11. Verde claro
12. Cyan claro
13. Rojo claro
14. Magenta claro
15. Marrón claro
16. Blanco

Estos colores los vamos a definir en un header para tenerlo más a mano y quizá en un futuro formar parte de la API del sistema. Así creamos el archivo ND_Colors.hpp en el include de NextDivel.

{% highlight c %}
#ifndef ND_COLOR_HPP
#define ND_COLOR_HPP

typedef enum ND_Color{ 
	ND_COLOR_BLACK			= 0,
	ND_COLOR_BLUE			= 1,
	ND_COLOR_GREEN			= 2,
	ND_COLOR_CYAN			= 3,
	ND_COLOR_RED			= 4,
	ND_COLOR_MAGENTA		= 5,
	ND_COLOR_BROWN			= 6,
	ND_COLOR_LIGHT_GREY		= 7,
	ND_COLOR_DARK_GREY		= 8,
	ND_COLOR_LIGHT_BLUE		= 9,
	ND_COLOR_LIGHT_GREEN	= 10,
	ND_COLOR_LIGHT_CYAN		= 11,
	ND_COLOR_LIGHT_RED		= 12,
	ND_COLOR_LIGHT_MAGENTA	= 13,
	ND_COLOR_LIGHT_BROWN	= 14,
	ND_COLOR_WHITE			= 15

} ND_Color;
#endif
{% endhighlight %}

A su vez vamos a definir nuevas funciones para escribir en pantalla de una manera más cómoda (no, todavía no vamos a implementar printf, sé que lo estais deseando). Crearemos un archivo y su header para un set de funciones relacionadas con la pantalla (ND_Screen.cpp y ND_Screen.hpp). En ellas vamos a crear funciones para: cambiar el color de las letras y el fondo, escribir frases y letras, limpiar la pantalla y desplazarnos por la pantalla. Seguimos usando las pantallas VGA pero ahora usaremos unos bytes que darán el color. ND_Screen.cpp quedaría como:

{% highlight c %}
#include <ND_Types.hpp>
#include <ND_Color.hpp>
#include <ND_Screen.hpp>

uint16_t *vidmem= (uint16_t *)0xB8000;
ND_Color backColour = ND_COLOR_BLACK;
ND_Color foreColour = ND_COLOR_WHITE;
uint8_t cursor_x = 0;
uint8_t cursor_y = 0;

/**
 * @brief Gets the current color
 * @param side The side to get the color
 * */
ND_Color ND::Screen::GetColor(ND_SIDE side)
{
	if(side==ND_SIDE_BACKGROUND){
		return backColour;
	}else{
		return foreColour;
	}
}
/**
 * @brief Sets the color to a screen side
 * @param side The side to set colour
 * @param colour The new colour
 * @see GetColor
 * */
void ND::Screen::SetColor(ND_SIDE side, ND_Color colour)
{
	if(side==ND_SIDE_BACKGROUND)
	{
		backColour=colour;
	}else{
		foreColour=colour;
	}
}
/**
 * @brief Puts the char on screen
 * @param c The character to write
 * */
void ND::Screen::PutChar(char c)
{
	uint8_t  attributeByte = (backColour << 4) | (foreColour & 0x0F);
	uint16_t attribute = attributeByte << 8;
	uint16_t *location;
	if (c == 0x08 && cursor_x)
	{
		cursor_x--;
	}else if(c == '\r')
	{
		cursor_x=0;
	}else if(c == '\n')
	{
		cursor_x=0;
		cursor_y=1;
	}
	if(c >= ' ') /* Printable character */
	{
		location = vidmem + (cursor_y*80 + cursor_x);
		*location = c | attribute;
		cursor_x++;
	}
	if(cursor_x >= 80) /* New line, please*/
	{
		cursor_x = 0;
		cursor_y++;
	}
	/* Scroll if needed*/
	uint8_t attributeByte2 = (0 /*black*/ << 4) | (15 /*white*/ & 0x0F);
	uint16_t blank = 0x20 /* space */ | (attributeByte2 << 8);
	if(cursor_y >= 25)
	{
       int i;
       for (i = 0*80; i < 24*80; i++)
       {
           vidmem[i] = vidmem[i+80];
       }

       // The last line should now be blank. Do this by writing
       // 80 spaces to it.
       for (i = 24*80; i < 25*80; i++)
       {
           vidmem[i] = blank;
       }
       // The cursor should now be on the last line.
       cursor_y = 24;
   }
}
/**
 * @brief Puts a complete string to screen
 * @param str The string to write
 * */
void ND::Screen::PutString(const char* str)
{
	int i=0;
	while(str[i]) 
	{
		ND::Screen::PutChar(str[i++]);
	}
}
/**
 * @brief Cleans the screen with a color
 * @param colour The colour to fill the screen
 * */
 void ND::Screen::Clear(ND_Color colour)
{
   // Make an attribute byte for the default colours
   uint8_t attributeByte = (colour /*background*/ << 4) | (15 /*white - foreground*/ & 0x0F);
   uint16_t blank = 0x20 /* space */ | (attributeByte << 8);

   int i;
   for (i = 0; i < 80*25; i++)
   {
       vidmem[i] = blank;
   }

   // Move the hardware cursor back to the start.
   cursor_x = 0;
   cursor_y = 0;
}
/**
 * @brief Sets the cursor via software
 * @param x The position of X
 * @param y The position of y
 * */
void ND::Screen::SetCursor(uint8_t x, uint8_t y)
{
	cursor_x=x;
	cursor_y=y;
}
{% endhighlight %}

El header será muy básico así que no lo incluyo aquí, pero destacar la definición del tipo ND_SIDE

{% highlight c %}
typedef enum ND_SIDE{
		ND_SIDE_BACKGROUND,
		ND_SIDE_FOREGROUND
}ND_SIDE;
{% endhighlight %}

También mencionar que hacemos uso del header ND_Types.hpp, este header nos define unos tipos básicos para uint8_t, uint16_t, etc basado en los char y los int. Realmente este header es el en el estándar C99 y de hecho mi ND_Types.hpp es un copia/pega del archivo desde Linux, así que podeis intercambiarlos y no pasaría nada (solo hay definiciones, ninguna función).

Para probar si este código funciona vamos a modificar el punto de entrada en C del kernel:

{% highlight c %}
	ND::Screen::Clear(ND_COLOR_WHITE);
	ND::Screen::SetColor(ND_SIDE_BACKGROUND,ND_COLOR_WHITE);
	ND::Screen::SetColor(ND_SIDE_FOREGROUND,ND_COLOR_GREEN);
	ND::Screen::PutString("NextDivel\n");
	ND::Screen::SetColor(ND_SIDE_FOREGROUND,ND_COLOR_BLACK);
	ND::Screen::PutString("Licensed under GNU GPL v2");
{% endhighlight %}

Y si seguimos estos pasos obtendríamos este resultado

![NextDivel, licensed under GNU GPLv2]({{ site.baseurl }}images/NextDivel-3.png)

Gracias a estas funciones que hemos creado podemos empezar a hacer pequeñas GUI, como por ejemplo un kernel panic que mostraremos cada vez que haya un error irrecuperable. Algo tal que así:

![NextDivel, kernel panic]({{ site.baseurl }}images/NextDivel-4.png)

Y esta pequeña GUI la hicimos solamente con estas funciones:

{% highlight c %}
void ND::Panic::Show(const char* error)
{
	ND::Screen::Clear(ND_COLOR_RED);
	ND::Screen::SetColor(ND_SIDE_BACKGROUND, ND_COLOR_WHITE);
	ND::Screen::SetColor(ND_SIDE_FOREGROUND, ND_COLOR_RED);
	ND::Screen::SetCursor(29,10); //(80-22)/2
	ND::Screen::PutString("NextDivel Kernel Error\n");
	ND::Screen::SetCursor(15,12);
	ND::Screen::PutString(error);
}
{% endhighlight %}

Y aprovecho para daros las gracias por la excelente acogida que tuvo el primer post.