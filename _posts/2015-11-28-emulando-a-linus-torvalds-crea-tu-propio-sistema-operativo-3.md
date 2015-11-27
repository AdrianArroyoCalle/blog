---
layout: post
title: "Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (III)"
description: Tercera parte de la serie tutorial para crear nuestro propio sistema operativo. Nos centramos en algunas funciones básicas de nuestra API.
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

> _Este artículo lo escribí para el blog en español [DesdeLinux](http://blog.desdelinux.net) el 1 de enero de 2014 y ahora lo dejo aquí, en mi blog personal. El artículo está tal cual, sin ninguna modificación desde aquella fecha._

![NextDivel]({{ site.baseurl }}images/NextDivel-3.png)

Continuamos esta serie de posts sobre cómo crear nuestro sistema operativo. Hoy no nos vamos a centrar en un tema sino que vamos a definir algunas funciones útiles de ahora en adelante. En primer lugar vamos a definir 3 funciones que cumplan la función de __memcpy__, __memset__ y __memcmp__:

{% highlight c %}
void* ND::Memory::Set(void* buf, int c, size_t len)
{
	unsigned char* tmp=(unsigned char*)buf;
	while(len--)
	{
		*tmp++=c;
	}
	return buf;
}
void* ND::Memory::Copy(void* dest,const void* src, size_t len)
{
	const unsigned char* sp=(const unsigned char*)src;
	unsigned char* dp=(unsigned char*)dest;
	for(;len!=0;len--) *dp++=*sp++;
	return dest;
}
int ND::Memory::Compare(const void* p1, const void* p2, size_t len)
{
	const char* a=(const char*)p1;
	const char* b=(const char*)p2;
	size_t i=0;
	for(;i<len;i++)
	{
		if(a[i] < b[i])
			return -1;
		else if(a[i] > b[i])
			return 1;
	}
	return 0;
}
{% endhighlight %}



Todas ellas se auto-implementan. Estas funciones yo las he sacado de una pequeña librería del C, la implementación suele ser parecida en todos los sistemas operativos. Ahora vamos a hacer 3 funciones simulares pero para manipular strings. Cumplirían la función de __strcpy__, __strcat__ y __strcmp__.

{% highlight c %}
size_t ND::String::Length(const char* src)
{
	size_t i=0;
	while(*src--)
		i++;
	return i;
}
int ND::String::Copy(char* dest, const char* src)
{
	int n = 0;
	while (*src)
	{
		*dest++ = *src++;
		n++;
	}
	*dest = '\0';
	return n;
}
int ND::String::Compare(const char *p1, const char *p2)
{
  int i = 0;
  int failed = 0;
  while(p1[i] != '\0' && p2[i] != '\0')
  {
    if(p1[i] != p2[i])
    {
      failed = 1;
      break;
    }
    i++;
  }
  if( (p1[i] == '\0' && p2[i] != '\0') || (p1[i] != '\0' && p2[i] == '\0') )
    failed = 1;

  return failed;
}
char *ND::String::Concatenate(char *dest, const char *src)
{
  int di = ND::String::Length(dest);
  int si = 0;
  while (src[si])
    dest[di++] = src[si++];
  
  dest[di] = '\0';

  return dest;
}
{% endhighlight %}

Vamos ahora con unas funciones bastante interesantes. Con estas funciones podremos leer y escribir en los puertos del hardware.   Esto normalmente se hace con ASM y corresponde (en x86) a las instrucciones __in__ y __out__. Para llamar de una manera fácil a ASM desde C se usa la instrucción __asm__, con el peligro que conlleva de que no es portable. A esta sentencia le añadimos el __volatile__ para que GCC no intente optimizar ese texto. Por otra parte la instrucción asm tiene una forma curiosa de aceptar parámetros, pero eso creo que se entiende mejor viendo los ejemplos.

{% highlight c %}
uint8_t ND::Ports::InputB(uint16_t _port)
{
	unsigned char rv;
	asm volatile("inb %1, %0" : "=a"(rv) : "dN"(_port));
	return rv;
}
uint16_t ND::Ports::InputW(uint16_t port)
{
	uint16_t rv;
	asm volatile("inw %1, %0" : "=a"(rv) : "dN"(port));
}
void ND::Ports::OutputB(uint16_t port, uint8_t value)
{
	asm volatile("outb %1, %0" : : "dN"(port), "a"(value));
}
{% endhighlight %}

Y hasta aquí el post 3, hoy no hemos hecho nada vistoso pero sí hemos definido una funciones que nos vendrán bien de cara a un futuro. Aviso a los usuarios de 64 bits que estoy trabajando en solucionar un __bug__ que impide compilar correctamente en 64 bits. En el siguiente post veremos un componente importante de la arquitectura x86, la GDT.