---
layout: post
title: "Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (IV)"
description: Cuarta parte de la serie tutorial para crear nuestro sistema operativo. Hoy revisamos la Global Descriptor Table (o GDT).
keywords:
 - linux
 - desdelinux
 - programacion
 - blogstack
 - sistemas-operativos
 - next-divel
 - kernel
 - gdt
 - x86
---
> _Este artículo lo escribí para el blog en español [DesdeLinux](http://blog.desdelinux.net) el 5 de enero de 2014 y ahora lo dejo aquí, en mi blog personal. El artículo está tal cual, sin ninguna modificación desde aquella fecha._


Bienvenidos de nuevo a esta serie de posts titulada “Emulando a Linus Torvalds”. Hoy veremos la GDT. Primero tenemos que ver que es la GDT. Según Wikipedia:

> _The Global Descriptor Table or GDT is a data structure used by Intel x86-family processors starting with the 80286 in order to define the characteristics of the various memory areas used during program execution, including the base address, the size and access privileges like executability and writability_

Que traducido sería una Tabla de Descriptores Global, una estructura de datos usada en los procesadores Intel x86 desde el 80286 para definir las características de varias áreas de memoria usadas durante la ejecución del programa.

Resumiendo, si estamos en un procesador Intel x86 deberemos definir una GDT para un correcto uso de la memoria. Nosotros no vamos a hacer mucha complicación y vamos a definir 3 entradas en la tabla:

* Una entrada NULL, obligatoria para todas las tablas.
* Una entrada para la sección data, usaremos el máximo, que en 32 bits son 4 GB.
* Una entrada para la sección code, usaremos el máximo, que en 32 bits son 4 GB.

Como veis data y code usarán el mismo espacio. Bien, ahora vamos a implementarlo. Para ello usaremos dos estructuras, la primera se encargará de contener un puntero hacia los datos reales de nuestra GDT. Y la segunda será un array con las entradas de la GDT. Primero vamos a definirlas.

{% highlight c %}
struct Entry{
	uint16_t limit_low;
    uint16_t base_low;
	uint8_t base_middle;
    uint8_t access;
    uint8_t granularity;
    uint8_t base_high;
} __attribute__((packed));

struct Ptr{
	uint16_t limit;
    uint32_t base;
} __attribute__((packed));
{% endhighlight %}

Habrán observado un curioso \_\_attribute\_\_((packed)) al final de las estructuras. Esto le dice al GCC que no optimice las estructuras porque lo que queremos es pasar los datos tal cual al procesador. Ahora vamos a hacer una función para instalar la GDT. Antes deberemos haber declarado las estructuras, ahora vamos a inicializarlas.

{% highlight c %}

struct ND::GDT::Entry gdt[3];
struct ND::GDT::Ptr gp;
void ND::GDT::Install()
{
	gp.limit=(sizeof(struct ND::GDT::Entry)*3)-1;
	gp.base=(uint32_t)&gdt;
}

{% endhighlight %}

Así conseguimos el construir el puntero que va hacia nuestra tabla de 3 entradas.

Ahora definimos una función común para poner los datos en las entradas

{% highlight c %}

void ND::GDT::SetGate(int num, uint32_t base, uint32_t limit, uint8_t access,uint8_t gran)
{
	gdt[num].base_low=(base & 0xFFFF);
	gdt[num].base_middle=(base >> 16) & 0xFF;
	gdt[num].base_high=(base >> 24) & 0xFF;
	gdt[num].limit_low=(limit & 0xFFFF);
	gdt[num].granularity=(limit >> 16) & 0x0F;
	gdt[num].granularity |= (gran & 0xF0);
	gdt[num].access=access;
}

{% endhighlight %}

Y la llamamos 3 veces desde la función de instalar

{% highlight c %}

ND::GDT::SetGate(0,0,0,0,0); /* NULL segmente entry */
ND::GDT::SetGate(1,0,0xFFFFFFFF,0x9A,0xCF); /* 4 GiB for Code Segment */
ND::GDT::SetGate(2,0,0xFFFFFFFF,0x92,0xCF); /* 4 GiB for Data segment */

{% endhighlight %}

Por último debemos decirle al procesador que tenemos una GDT, para que la cargue, y en nuestro caso al cargar el kernel con GRUB, sobreescribir la GDT de GRUB. Para cargar la GDT existe una instrucción en asm llamada lgdt (o lgdtl dependiendo de la sintaxis), vamos a usarla.

{% highlight c %}

asm volatile("lgdtl (gp)");
asm volatile(
	"movw $0x10, %ax \n"
	"movw %ax, %ds \n"
    "movw %ax, %es \n"
    "movw %ax, %fs \n"
    "movw %ax, %gs \n"
    "movw %ax, %ss \n"
    "ljmp $0x08, $next \n"
    "next: \n"
);

{% endhighlight %}

Bien una vez hayamos terminado esto nuestro sistema ya contará con GDT. En el siguiente capítulo veremos la IDT, una tabla muy parecida a la GDT pero con interrupciones. Yo he puesto unos mensajes de estado y confirmación con la GDT así que NextDivel ahora luce así:

![NextDivel y la GDT]({{ site.baseurl }}images/NextDivel-GDT.png)