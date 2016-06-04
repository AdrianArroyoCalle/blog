---
layout: post
title: Programando para Haiku - File panel - Parte II
description: Abriendo paneles para abrir y guardar archivos en Haiku/BeOS
date: "2016-06-04 21:10"
keywords:
 - programacion
 - blogstack
 - linux
 - ubuntu
 - haiku
 - beos
 - filepanel
 - cpp
---

Continuamos los tutoriales de programación en Haiku. Hoy veremos como usar el File Panel. ¿Qué es el File Panel? El File Panel es el diálogo que nos aparece cuando queremos abrir o guardar un archivo o carpeta. En todos los sistemas operativos gráficos es similar.

![File Panel de Windows](http://i.stack.imgur.com/seGHw.png)

## BFilePanel

La clase básica es BFilePanel. Esta clase se encarga de mostrar esa ventanita que nos deja elegir el archivo o carpeta para abrir o para guardar. Lo primero que tenemos que saber si queremos hacer un File Panel es si va a ser para abrir un archivo existente o para guardar un nuevo archivo. Así, distinguimos entre B_OPEN_PANEL y B_SAVE_PANEL. Si estamos dentro de un B_OPEN_PANEL además indicaremos si aceptamos archivos, carpetas, enlaces simbólicos o alguna combinación de estas cosas. Por último, ¿cómo recibimos la información del panel? Pues usando BMessage, como es habitual en Haiku/BeOS. Pero hay que indicar quién va procesar el mensaje, el conocido como BMessenger. Veamos código: 

{% highlight cpp %}
const uint32 OPEN_FILE = 42;
BFilePanel* filepanel = new BFilePanel(B_OPEN_PANEL,new BMessenger(this),NULL,B_FILE_NODE,new BMessage(OPEN_FILE));
filepanel->Show();
{% endhighlight %}

En este código creamos un file panel para abrir un archivo. El BMessenger encargado de procesarlo será el del mismo contexto en el que se ejecute este código. Hay que tener en cuenta que tanto BApplication como BWindow heredan de BMessenger y por tanto cualquier objeto de estas clases es apto. El siguiente parámetro es la carpeta por defecto, que con NULL la dejamos a elección de Haiku. Luego indicamos que queremos abrir archivos, no carpetas ni enlaces simbólicos. Por último especificamos el ID del BMessage que enviará el panel. Esto nos servirá para después saber que ID tenemos que leer dentro de la función MessageReceived del BMessenger. Por último mostramos el panel para que el usuario decida el archivo a abrir. Si la acción es cancelada también será disparado el mensaje, tendremos que comprobar si el usuario eligió el archivo o cerró el diálogo.

![Haiku File Panel](https://api.haiku-os.org/BFilePanel_example.png)

## Leer la respuesta

Dentro de la función MessageReceived del BMessenger tenemos que accionar un caso especial si el ID del BMessage es el que hemos especificado en el panel.

{% highlight cpp %}
void MiVentana::MessageReceived(BMessage* msg)
{
	switch(msg->what){
    	case READ_FILE: {
			if (msg->HasRef("refs")) {
	  			entry_ref ref;
	  			if (msg->FindRef("refs", 0, &ref) == B_OK) {
					BEntry entry(&ref, true);
					BPath path;
					entry.GetPath(&path);
					std::cout << "El archivo es " << path.Path() << std::endl; 
			 	}
			}
			break;
  		}
    }

}
{% endhighlight %}

Tenemos que comprobar si el mensaje tiene la propiedad "refs". La propiedad "refs" la ajusta el File Panel cuando se ha seleccionado un archivo. Si la propiedad existe entonces lo leemos. Leeremos una entry_ref. Un entry_ref es una entrada dentro del sistema de archivos. Sin embargo esta estructura es de bajo nivel y no sabe exactamente donde se ubica. BEntry representa localizaciones dentro del sistema de archivos. Se construye con un entry_ref y esta clase ya sabe donde se ubica de forma legible por un humano (o un programador perezoso). Si queremos saber la ruta del archivo antes tendremos que crear un objeto vacío BPath que llenaremos con contenido. Finalmente la ruta, como string, la podremos leer llamando a la función Path dentro del objeto BPath.

Ya hemos visto como se usan los file panel en Haiku. Los file panel de guardar archivo se programan exactamente igual cambiando esa pequeña flag al principio.