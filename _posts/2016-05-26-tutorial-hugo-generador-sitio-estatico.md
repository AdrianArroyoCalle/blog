---
layout: post
title: Tutorial de Hugo en español, generador de sitios estáticos
description: "Jekyll, Hexo, Pelican... Hay muchos generadores, pero el mejor es Hugo. Crea tu sitio web con el mejor generador de sitios estáticos"
date: "2016-05-26 12:22:00"
keywords:
 - programacion
 - blogstack
 - hugo
 - linux
 - ubuntu
 - web
 - html
 - go
 - jekyll
---

Los generadores de sitios estáticos son aplicaciones que dados unos ficheros generan un sitio web completo, listo para ser desplegado en Apache o Nginx. El generador es llamado bajo demanda del administrador por lo que, al contrario que en un CMS completo, este programa solo genera las páginas una sola vez, reduciendo considerablemente la carga de trabajo y el precio y aumentando en velocidad y rendimiento.

![Página web de Hugo]({{ site.img }}/hugo.png)


Los generadores más populares son:

| Nombre | Lenguajde| Plantillas | Licencia | Sitio web |
|--------|----------|------------|----------|-----------|
| Jekyll | Ruby     | Liquid     | MIT      | [http://jekyll.rb.com](http://jekyllrb.com)|
| Hexo   | JavaScript | EJS y Swig     | MIT     | [http://hexo.io](http://hexo.io)|
| Hugo   | Go      | Go Template, Acer y Amber | Apache   | [http://gohugo.io](http://gohugo.io)|
| Pelican | Python | Jinja2 | GPL | [http://blog.getpelican.com/](http://blog.getpelican.com/) |

Además es también bastante conocido [Octopress](http://octopress.org/) pero Octopress no es más que Jekyll con una colección de utilidades extra, el núcleo del programa sigue siendo Jekyll.

¿Por qué voy a elegir Hugo? Yo empecé con Jekyll y me gustó. Sin embargo Liquid no me acabó de convencer nunca y miré otras alternativas. Hexo me pareció excelente si lo que quieres hacer es un blog, funciona muy bien y es más rápido que Jekyll pero Jekyll tenía la ventaja de que se podía usar no solo en blogs, sino en cualquier web en general. Entonces oí hablar de Hugo. Hugo es el más rápido y el más flexible. No está enfocado solo en blogs, soporta todo lo que le eches. Sin embargo me parece que Hugo no es el más sencillo de configurar, así que aquí va el tutorial.

## Instalando Hugo

Hugo está hecho en Go, quiere decir que está compilado y por tanto hay una versión diferente para cada sistema operativo. Descarga la versión de tu sistema operativo [desde aquí](https://github.com/spf13/hugo/releases). Si usas GNU/Linux es posible que tu distro haya empaquetado ya Hugo. Búscalo.

Una vez lo tengamos instalado comprobamos que todo esté en orden:

```
hugo version
```

Por defecto Hugo no trae ningún tema. Si quieres instalarte uno y no crear uno de cero puedes clonarlos desde Git. Si quieres probar los temas antes de instalarlos no dejes de mirar [Hugo Themes](http://themes.gohugo.io/)

```
git clone --recursive https://github.com/spf13/hugoThemes ~/themes
```

Si queremos tener coloreado de sintaxis podemos usar Pygments. Si tienes PIP instalado es fácil.

```
sudo pip install Pygments
```

Además si quieres activar el autocompletado de Bash solo tienes que hacer 

```
sudo hugo gen autocomplete
. /etc/bash_completion
```

Y con esto ya tenemos Hugo instalado correctamente. Ejecuta:

```
hugo new site MiSitioSupercalifragilisticoespialidoso
```

![Hugo Themes]({{ site.img }}/hugo-themes.png)

## Organización en Hugo

En Hugo tenemos que tener muy en cuenta la organización de los ficheros. En primer lugar van los __themes__. Como puedes comprobar la carpeta `themes` generada esta vacía. Para ir probando los distintos temas puedes hacer un sencillo enlace simbólico entre la carpeta con los temas descargada y esta.

```
rmdir themes
ln -s ../themes .
```

Veamos el resto de carpetas:

* __archetypes__. Arquetipos. Son plantillas para cuando añadimos un nuevo elemento. Por ejemplo, podemos tener un arquetipo de post sobre un vídeo de YouTube. Es posible crear un arquetipo que contenga configuración ya específica (categorías, reproductor insertado, etc) y que cuando escribamos ya lo tengamos medio hecho. A la hora de generar el sitio los arquetipos de origen no son tenidos en cuenta.
* __config.toml__ (o config.json o config.yaml). Este archivo contiene la configuración del sitio.
* __content__. Aquí va el contenido central de la web. Dentro de content debes crear tantas carpetas como secciones tengas (aunque se puede sobreescribir vía configuración, es práctica recomendada). Cada sección tiene asignado un layout distinto. Dentro de la carpeta de cada sección la organización es libre, los archivos suelen ser de Markdown, pero HTML puro también vale.
* __layouts__. ¿Cómo se organiza el contenido? Los layouts son la respuesta. Por cada sección hay que crear mínimo dos layouts, uno para mostrar un contenido solamente y otro para múltiples contenidos del mismo tipo (listas).
* __data__. Aquí puedes almacenar archivos en JSON, YAML o TOML a los que puedes acceder desde Hugo. Estos archivos pueden contener cualquier tipo de información, piensa en ellos como en una especie de base de datos.
* __static__. El contenido estático, imágenes, JavaScript, CSS, que no deba ser procesado por Hugo debes ponerlo aquí.

## Configuración

Dentro del fichero config.toml hay que editar unos cuantos valores.

{% highlight toml %}
baseurl = "mi-sitio.com" # La dirección base del sitio
languageCode = "es-es" # El idioma de la web
title = "" # El título de la web
theme = "bleak" # El tema que se va a aplicar al contenido
googleAnalytics = "" # Código de seguimiento de Google Analytics
disqusShortname = ""

[Params] # A estos parámetros se puede acceder de forma directa con .Site.Params.NOMBRE
Author = "Adrián Arroyo"

{% endhighlight %}

También es configurable __Blackfriday__ el motor de Markdown de Hugo, aunque las opciones por defecto son más que suficientes.


## Creando contenido

Crea un archivo dentro de content. Puede estar dentro de una sección si así lo prefieres. En Hugo al igual que en Jekyll cada contenido tiene un _front matter_, es decir, los metadatos se añaden al principio en un formato que no se va a renderizar. Hugo soporta TOML, YAML y JSON. Si usamos TOML, los delimitadores del _front matter_ serán `+++`, si usamos YAML `---` y si usamos JSON tenemos que poner un objeto con las llaves, `{}`

```
+++
title = "El título de la entrada"
description = "Una pequeña descripción"
tags = ["hola","otra","etiqueta"]
date = "2016-05-23"
categories = ["Sobre el blog"]
draft = true
+++

Aquí va el contenido en Markdown o HTML que va a ser renderizado.
```

Podemos crear variables nuevas a las que podremos acceder desde .Params. Otras opciones predefinidas son type (que sobreescriben el valor de la sección), aliases (que permite hacer redirecciones), weight (la prioridad cuando el contenido sea ordenado) y slug (permite ajustar la URL del contenido).



## Modificando el tema

Puedes modificar el tema usando la carpeta layouts. En el fondo un tema es una colección de layouts y recursos estáticos que son combinados con el tuyo. Si ya usas un tema y solo quieres realizar pequeñas modificaciones puedes editar el tema directamente. Si quieres añadir nuevas secciones o crear un tema de 0 entra a la carpeta layouts.

Hay varias subcarpetas dentro de layouts importantes:

* _default. Es la que se usa cuando no hay otro disponible. Normalmente los temas sobreescriben esta carpeta. Si sobreescribes esta carpeta perderás el tema.
* index.html. La página de entrada a la web
* partials. En este carpeta se pueden guardar trozos HTML reutilizables para ser usados por los layouts.
* shortcodes. Son pequeños trozos de HTML reutilizables con parámetros de entrada para ser usados por el contenido.

Dentro de cada layout (como en _default) tiene que haber mínimo dos archivos. Un archivo single.html que se usará cuando solo se tenga que representar una unidad de ese contenido y un archivo list.html que se usará cuando sea necesario mostrar un conjunto de esos contenidos.

Estos archivos han de programarse usando el motor de plantillas de Go y la API de Hugo. Un archivo `single.html` básico que muestra el título y el contenido tal cual sería así.

```
{{ partial "header.html" . }}
{{ partial "subheader.html" . }}
<section id="main">
  <h1 id="title">{{ .Title }}</h1>
  <div>
        <article id="content">
           {{ .Content }}
        </article>
  </div>
</section>
{{ partial "footer.html" . }}
```

Dentro de las páginas list.html es práctica habitual definir una vista `li.html` como un elemento individual. Esos elementos individuales se unen para formar la lista en `list.html`.

## Algunos extras

Los shortcodes son pequeños trozos de HTML que aceptan parámetros. Podemos usarlos en el contenido. Piensa en ellos como Mixins de CSS o funciones de JavaScript. Por ejemplo, para marcar un resaltado de sintaxis:

```
{{< highlight html >}}
<section id="mira-este-super-codigo">
	<p class="html-is-broken">Rompiendo el HTML</p>
</section>
{{< /highlight >}}
```
O un enlace dentro de nuestra web:
```
{{< ref "blog/este-es-otro-post-fantastico.md" >}}
```