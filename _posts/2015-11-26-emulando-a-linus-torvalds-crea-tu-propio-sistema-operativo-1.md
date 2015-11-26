---
layout: post
title: Emulando a Linus Torvalds: Crea tu propio sistema operativo desde 0 (I)
description: Serie tutorial de cómo crear tu propio sistema operativo desde cero, para procesadores x86.
keywords:
 - retro
 - linux
 - ubuntu
 - programacion
 - blogstack
 - desdelinux
 - sistemas-operativos
 - kernel
 - grub
 - qemu
---

> _Este artículo lo escribí para el blog en español [DesdeLinux](http://blog.desdelinux.net) el 27 de diciembre de 2013 y ahora lo dejo aquí, en mi blog personal. El artículo está tal cual, sin ninguna modificación desde aquella fecha._

En esta serie vamos a emular a __Linus Torvalds__, vamos a crear nuestro sistema operativo desde 0. En este primer episodio vamos a ver el arranque y pondremos un texto en pantalla desde nuestro kernel.

![Linus Torvalds]({{ site.baseurl}}images/LinusTorvalds.jpg)

En mi caso el sistema operativo se llama __NextDivel__. La primera decisión que debemos hacer nada más plantearnos el sistema operativo es ¿cuál va a ser el bootloader?

Aquí existen múltiples variantes, e incluso podríamos crear uno nosotros; sin embargo, en este tutorial voy a usar GRUB, porque la mayoría conoce más o menos algo de él. Creamos una carpeta que será el root de nuestro sistema operativo y allí creamos la carpeta /boot/grub

```
mkdir nextroot && cd nextroot
mkdir -p boot/grub
```

Allí creamos el fichero grub.cfg de la siguiente manera:

```
menuentry "NextDivel" {
	echo "Booting NextDivel"
	multiboot /next/START.ELF
	boot
}
```

En este fichero hemos visto como __GRUB__ cargará nuestro kernel, en este caso, en /next/START.ELF. Ahora debemos crear nuestro kernel.

Para ello necesitaremos el __GCC__ y __GAS__ (el ensamblador del proyecto __GNU__, suele venir con el gcc). Así pues vamos a crear el kernel.

Primero hacemos un archivo llamado kernel.asm. Este archivo contendrá el punto de inicio de nuestro kernel y además definirá el multiboot (una característica de algunos bootloaders como __GRUB__). El contenido de kernel.asm será:

{% highlight asm %}
.text
.globl start
start:
	jmp multiboot_entry
	.align 4
multiboot_header:
	.long 0x1BADB002
	.long 0x00000003
	.long -(0x1BADB002+0x00000003)
multiboot_entry:
	movl $(stack + 0x4000), %esp
	call NextKernel_Main
loop: hlt
	jmp loop
.section ".bss"
	.comm stack,0x4000
{% endhighlight %}

Todo lo relacionando con multiboot es simplemente seguir la especificación nada más. Todo empezará en start, llamará a multiboot_entry, habremos definido el multiboot header en los primeros 4k y lo pondremos (con movl).

Más tarde llamamos a NextKernel_Main que es nuestra función en C del kernel. En el loop hacemos un halt para parar el ordenador. Esto se compila con:

```
as -o kernel.o -c kernel.asm
```

Ahora vamos a entrar a programar en C. Pensarás que ahora todo es pan comido, ponemos un __printf__ en __main__ y ya está, lo hemos hecho.

Pues no, ya que printf y main son funciones que define el sistema operativo, ¡pero nosotros lo estamos creando! Solo podremos usar las funciones que nosotros mismos definamos.

En capítulos posteriores hablaré de como poner nuestra propia libraría del C (glibc, bionic, newlibc) pero tiempo al tiempo. Hemos hablado que queremos poner texto en pantalla, bueno veremos como lo hacemos.

Hay dos opciones, una es llamar a la __BIOS__ y otra es manejar la memoria de la pantalla directamente. Vamos a hacer esto último pues es más claro desde C y además nos permitirá hacerlo cuando entremos en modo protegido.

Creamos un fichero llamado NextKernel_Main.c con el siguiente contenido:

{% highlight c %}
int NextKernel_Main(/*struct multiboot *mboot_ptr*/)
{
	const char* str="NextDivel says Hello World", *ch;
	unsigned short* vidmem=(unsigned short*)0xb8000;
	unsigned i;
	for(ch=str, i=0;*ch;ch++, i++)
		vidmem[i]=(unsigned char) *ch | 0x0700;

	return 0;
}

{% endhighlight %}

Con esto manipulamos directamente la memoria __VGA__ y caracter a caracter lo vamos escribiendo. Compilamos desactivando la stdlib:

```
gcc -o NextKernel_Main.o -c NextKernel_Main.c -nostdlib -fPIC -ffreestanding
```

Si has llegado hasta aquí querrás probar ya tu nuevo y flamante sistema operativo, pero todavía no hemos terminado. Necesitamos un pequeño fichero que diga al compilador en que posición del archivo dejar cada sección. Esto se hace con un linker script. Creamos link.ld:

```
ENTRY(start)
SECTIONS
{
	. = 0x00100000;

	.multiboot_header :
	{
		*(.multiboot_header)
	}
    .text :
    {
        code = .; _code = .; __code = .;
        *(.text)
        . = ALIGN(4096);
    }

    .data :
    {
        data = .; _data = .; __data = .;
        *(.data)
        *(.rodata)
        . = ALIGN(4096);
    }

    .bss :
    {
        bss = .; _bss = .; __bss = .;
        *(.bss)
        . = ALIGN(4096);
    }

    end = .; _end = .; __end = .;
}
```

Con esto definimos la posición de cada sección y el punto de entrada, start, que hemos definido en kernel.asm. Ahora ya podemos unir todo este mejunje:

```
gcc -o START.ELF kernel.o NextKernel_Main.o -Tlink.ld -nostdlib -fPIC -ffreestanding -lgcc
```

Ahora copiamos START.ELF al /next dentro de nuestra carpeta que simula el root de nuestro sistema operativo. Nos dirigimos a la carpeta root de nuestro sistema operativo nuevo con la consola y verificamos que hay dos archivos: uno /boot/grub/grub.cfg y otro /next/START.ELF.

Vamos al directorio superior y llamamos a una utilidad de creación ISOs con GRUB llamada _grub-mkrescue_

```
grub-mkrescue -o nextdivel.iso nextroot
```

Una vez hayamos hecho esto tendremos una ISO. Esta ISO puede abrirse en ordenadores __x86__ (64 bits también) y máquinas virtuales. Para probarlo, voy a usar __QEMU__. Llamamos a QEMU desde la línea de comandos:

```
qemu-system-i386 nextdivel.iso
```

Arrancará __SeaBIOS__ y más tarde tendremos GRUB. Después si todo va correcto veremos nuestra frase.
Pensarás que esto es difícil, te respondo, sí lo es.

Realmente crear un sistema operativo es difícil y eso que este de aquí no hace nada útil. En próximos capítulos veremos como manejar colores en la pantalla, reservar memoria y si puedo, como obtener datos del teclado.

Si alguien no quiere copiar todo lo que hay aquí, tengo un repositorio en GitHub (más elaborado) con el sistema operativo __NextDivel__. Si quieres compilar NextDivel solo tienes que tener git y cmake:

```
git clone https://github.com/AdrianArroyoCalle/next-divel

cd next-divel

mkdir build && cd build

cmake ..

make

make DESTDIR=next install

chmod +x iso.sh

./iso.sh

qemu-system-i386 nextdivel.iso
```

Os animo a colaborar en NextDivel si tienes tiempo y ganas de crear un sistema operativo. Quizá incluso superior a Linux… el tiempo lo dirá.