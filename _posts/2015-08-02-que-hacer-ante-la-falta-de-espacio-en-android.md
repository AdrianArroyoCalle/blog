---
layout: post
title: ¿Qué hacer ante la falta de espacio en Android?
description: Me pide mucha gente que les ayude a liberar espacio de su teléfono. Así que voy a juntar un poco todo lo que conozco. En algunos pasos voy a asumir que tenemos el teléfono con root.
keywords:
 - android
 - linux
 - ubuntu
 - moviles
 - root
 - blogstack
---

Me pide mucha gente que les ayude a liberar espacio de su teléfono. Así que voy a juntar un poco todo lo que conozco. En algunos pasos voy a asumir que tenemos el teléfono con __root__.

![Bien predica quien bien vive - Muñeco Android]({{ site.baseurl }}images/Android.jpg)

## 0. Pasar imágenes, vídeo y WhatsApps a la SD

Pongo 0 porque esto lo deberías haber hecho nada más recibir el teléfono. Si el teléfono no soporta SD, borrar cosas y si se consideran importantes pasar al ordenador.

## 1. Borrar la caché de las aplicaciones

Se puede hacer desde la interfaz de ajustes de Android o desde Link2SD.

## 2. Pasar aplicaciones a la tarjeta SD

Usa Link2SD. Tiene un modo básico con el script app2sd y otro más avanzado que funciona con particiones.

## 3. Borrar aplicaciones innecesarias de usuario

Usa Link2SD o en los ajustes de Android.

## 4. Borrar aplicaciones innecesarias del sistema

Usa Link2SD. Usa esto con cuidado. Me encuentro que mucha gente puede borrar sin problemas las Play cosas (menos Play Store) y las aplicaciones de la operadora. También puedes:

```
mount -o remount,rw /system
rm /system/app/APLICACION.apk
mount -o remount,ro /system
```

## 5. Limpia la Dalivk Cache

Usa Link2SD. Si no lo puedes usar

```
rm /data/dalvik-cache/*
```

## 6. Borrar datos de algunas aplicaciones

Ciertas aplicaciones usan datos a lo tonto. Mejor borrar y empezar de nuevo. Sé cuidadoso.

## 7. Pasar SD Maid

Si lo tienes instalado perfecto. Si no, sigue más adelante.

## 8. Cambiar el porcentaje de alerta

En la terminal o usando adb shell.

```
sqlite3 /data/data/com.android.providers.settings/databases/settings.db
insert into secure (name, value) VALUES('sys_storage_threshold_percentage','5');
insert into gservices (name, value) VALUES('sys_storage_threshold_percentage','5');
.quit
```

¿Y si no tengo SQlite 3 instalado en mi teléfono? Algo totalmente comprensible, en cuyo caso deberás descargar una versión ya compilada (también puedes compilarla tú con el Android NDK). En [este hilo de XDA Developers](http://forum.xda-developers.com/showthread.php?t=2730422) lo puedes encontrar actualizado.

## 9. Optimizar bases de datos

```
for i in $(find /data -iname "*.db"); do
sqlite3 $i 'VACUUM;';
done
```

quizá esto también valga

```
find /data -iname "*.db" -exec sqlite3 {} "VACUUM;" \;
```

## 10. Borrar archivos generados por Android

```
rm /data/tombstones/*
rm /data/system/dropbox/*
rm /data/system/usagestats/*
```

## 11. Reseteo de fábrica

Solo en caso excepcional deberías plantearte empezar de nuevo. En muchos dispositivos se accede al recovery por Volumen Bajo + Boton Power. Desde allí buscamos la opción de Factory Reset o directamente instalamos otra ROM más ligera.

## Más

Si alguien conoce más métodos para reducir el espacio usado en Android me lo puede comentar.