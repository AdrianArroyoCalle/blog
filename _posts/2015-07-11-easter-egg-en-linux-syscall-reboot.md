---
layout: post
title: "Easter egg en Linux: la syscall reboot"
description: "El kernel Linux tiene guardada una pequeña curiosidad en su interior"
keywords:
 - linux
 - ubuntu
 - blogstack
 - easteregg
 - curiosidades
---

Ayer me encontré con un curioso easter egg en el interior de Linux que no conocía. Se trata de la syscall `reboot` usada para reiniciar el ordenador. Primero veamos lo que nos dice el manual sobre reboot

```
man 2 reboot
#o también en GNOME
yelp 'man:reboot(2)'
```
![Página del manual de reboot]({{ site.baseurl }}images/man-reboot.png)

Tiene algo interesante. Los dos primeros parámetros para llamar a reboot se llaman `magic` y `magic2` y no son muy importantes realmente porque reboot también admite una versión sin esos parámetros.

Si leemos algo más podemos ver que `magic` debe ser igual al valor de `LINUX_REBOOT_MAGIC1`, que es 0xfee1dead (_feel dead ?_) y que para `magic2` se admiten varios posibles valores

* `LINUX_REBOOT_MAGIC2` que es 672274793
* `LINUX_REBOOT_MAGIC2A` que es 85072278
* `LINUX_REBOOT_MAGIC2B` que es 369367448
* `LINUX_REBOOT_MAGIC2C` que es 537993216

¿Por qué la constante primera está en hexadecimal y el resto no? ¿Qué pasa si pasamos los posibles valores de `magic2` a hexadecimal?

> 672274793 = 0x28121969

> 85072278 = 0x05121996

> 369367448 = 0x16041998

> 537993216 = 0x20112000

¿A qué se parece? ¿Serán fechas? Veamos la primera. 28 de diciembre de 1969. ¿Qué ocurrió? ¡Pues que nació Linus Torvalds ese día! Y el resto de fechas son las fechas de nacimiento de sus hijas. Así que ya sabes, cada vez que reinicias en Linux estás usando fechas de nacimiento de la familia Torvalds.

![Linus Torvalds]({{ site.baseurl }}images/Torvalds.jpg)
