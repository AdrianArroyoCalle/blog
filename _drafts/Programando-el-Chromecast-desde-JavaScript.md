---
layout: post
title: Programando el Chromecast desde JavaScript
description: Chromecast (Google Cast) es una potente herramienta para reproducir contenido multimedia en los televisores. Chromecast reproduce vídeos y aplicaciones en HTML5.
date: "2016-04-02 14:12:00"
keywords:
 - programacion
 - blogstack
 - chromecast
 - javascript
 - google
 - html5
 - node.js
---

Chromecast (o Google Cast) es un dongle, un pequeño aparato, que se conecta a una entrada HDMI y permite disfrutar de contenido multimedia a un precio bastante ajustado (35$). Oficialmente solo se puede programar usando los SDK de iOS, Android y Chrome pero la comunidad ha conseguido replicar el protocolo interno. Chromecast ha tenido varios protocolos de comunicación pero el importante para lo que vamos a realizar se llama CASTv2.

![Chromecast]({{ site.img }}/chromecast-box.jpg)

## ¿Cómo funciona Chromecast por dentro?

Primero voy a explicar como funciona el Chromecast. Chromecast sigue la filosofía de los Chromebooks, en el que todo el sistema es el navegador web, en este caso Chrome. Una app se conecta a Chromecast a través del protocolo de descubrimiento, deben estar en la misma red Wi-Fi. La aplicación solicita iniciar una aplicación, para lo cual manda el ID de la aplicación que desea abrir. Chromecast busca en la base de datos de Google ([https://cast.google.com](https://cast.google.com), tasa de registro de 5$) y allí le indicará una URL.

Chromecast abre la web y ejecuta la aplicación, que usando una librería de JavaScript le permite comunicarse con la app original. Podemos distinguir sin embargo varias aplicaciones "preinstaladas". Son webs como el resto pero están alojadas por Google sin marca. Son DefaultMediaReceiver y StyledMediaReceiver. Se trata de dos reproductores multimedia básicos, que soportan vídeo en MP4 y WebM desde una URL, subtítulos, carátula y en el caso de StyledMediaReceiver es posible modificar un poco el aspecto del reproductor.

![Esquema de Chromecast]({{ site.img }}/chromecast.png)

## Reproduciendo un vídeo con Chromecast, Node.js y DefaultMediaReceiver

Como hemos visto, reproducir un vídeo en Chromecast no es muy difícil. Para ello me voy a ayudar en la librería [chromecast-js](https://github.com/guerrerocarlos/chromecast-js) que en última instancia remite a [node-castv2-client](https://github.com/thibauts/node-castv2-client).

En un ordenador, dentro de la misma red Wi-Fi que el Chromecast y con Node.js instalado ejecutamos:

```
mkdir chromecast-video
cd chromecast-video
npm install chromecast-js
```

Creamos un archivo de JavaScript con el siguiente contenido

{% highlight js %}

var chromecastjs = require('chromecast-js'); // Obtenemos la librería

var browser = new chromecastjs.Browser(); // Iniciamos la búsqueda

browser.on('deviceOn', function(device){ // Cuando encuentre un dispositivo...
  device.connect(); // Nos conectamos a él
  device.on('connected', function(){ // Y cuando nos conectemos

    device.play('http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4', 60, function(){ // Mandamos reproducir el vídeo Big Buck Bunny, en MP4, no desde el principio, sino desde el primer minuto
        console.log('Reproduciendo en el Chromecast!');
    });

    setTimeout(function(){ // Pasados 30 segundos paramos el vídeo
        device.pause(function(){
            console.log('Paused!')
        });
    }, 30000);

    setTimeout(function(){ // Pasados otros 10 segundos más, se corta la retransmisión
        device.stop(function(){
            console.log('Stoped!')
        });
    }, 40000);

  })
})

{% endhighlight %}

Es un ejemplo muy sencillo. Como veis, Chromecast se conecta directamente al vídeo que reproduce, el dispositivo de control solo es eso, solo controla, nunca envía la película.

## Personalizando con StyledMediaReceiver

El módulo `chromecast-js` también permite usar el StyledMediaReceiver, cuyo funcionamiento es idéntico al de DefaultMediaReceiver pero se le puede personalizar el aspecto. Además añadimos subtítulos (formato WebVTT) y una carátula.

{% highlight js %}
var chromecastjs = require('chromecast-js')

var browser = new chromecastjs.Browser()

var media = {
    url : 'http://commondatastorage.googleapis.com/gtv-videos-bucket/big_buck_bunny_1080p.mp4', // El vídeo
    subtitles: [{
        language: 'en-US',
        url: 'http://carlosguerrero.com/captions_styled.vtt',
        name: 'English',
    },
    {
        language: 'es-ES',
        url: 'http://carlosguerrero.com/captions_styled_es.vtt',
        name: 'Spanish',
    }
    ], // Los subítulos, un fichero para inglés y otro para español, en formato WebVTT
    cover: {
        title: 'Big Bug Bunny',
        url: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg' // Carátula, se muestra cuando el vídeo se está cargando
    },
    subtitles_style: { 
          backgroundColor: '#FFFFFFFF', // see http://dev.w3.org/csswg/css-color/#hex-notation
          foregroundColor: '#000FFFF', // see http://dev.w3.org/csswg/css-color/#hex-notation
          edgeType: 'DROP_SHADOW', // can be: "NONE", "OUTLINE", "DROP_SHADOW", "RAISED", "DEPRESSED"
          edgeColor: '#AA00FFFF', // see http://dev.w3.org/csswg/css-color/#hex-notation
          fontScale: 1.5, // transforms into "font-size: " + (fontScale*100) +"%"
          fontStyle: 'BOLD_ITALIC', // can be: "NORMAL", "BOLD", "BOLD_ITALIC", "ITALIC",
          fontFamily: 'Droid Sans',
          fontGenericFamily: 'CURSIVE', // can be: "SANS_SERIF", "MONOSPACED_SANS_SERIF", "SERIF", "MONOSPACED_SERIF", "CASUAL", "CURSIVE", "SMALL_CAPITALS",
          windowColor: '#AA00FFFF', // see http://dev.w3.org/csswg/css-color/#hex-notation
          windowRoundedCornerRadius: 10, // radius in px
          windowType: 'ROUNDED_CORNERS' // can be: "NONE", "NORMAL", "ROUNDED_CORNERS"
    } // Aquí creamos un estilo para los subtítulos, la notación es fácil si ya conoces CSS
}


browser.on('deviceOn', function(device){
  device.connect()
  device.on('connected', function(){

    // Iniciamos la retransmisión, pero esta vez enviamos más información al Chromecast, usaremos StyledMediaReceiver
    device.play(media, 0, function(){
        console.log('Playing in your chromecast!')

        setTimeout(function(){
            console.log('subtitles off!')
            device.subtitlesOff(function(err,status){ // Desactivamos los subtítulos
                if(err) console.log("error setting subtitles off...")
                console.log("subtitles removed.")
            });
        }, 20000);

        setTimeout(function(){
            console.log('subtitles on!')
            device.changeSubtitles(1, function(err, status){ // Restablecemos los subtítulos, pero al Español
                if(err) console.log("error restoring subtitles...")
                console.log("subtitles restored.")
            });
        }, 25000);

        setTimeout(function(){
            device.pause(function(){
                console.log('Paused!')
            });
        }, 30000);

        setTimeout(function(){
            device.unpause(function(){
                console.log('unpaused!')
            });
        }, 40000);

        setTimeout(function(){
            console.log('I ment English subtitles!')
            device.changeSubtitles(0, function(err, status){
                if(err) console.log("error restoring subtitles...")
                console.log("English subtitles restored.")
            });
        }, 45000);

        setTimeout(function(){
            console.log('Increasing subtitles size...')
            device.changeSubtitlesSize(10, function(err, status){ // Cambiamos el tamaño de los subtítulos
                if(err) console.log("error increasing subtitles size...")
                console.log("subtitles size increased.")
            });
        }, 46000);

        setTimeout(function(){
            device.seek(30,function(){ // Nos movemos dentro del vídeo
                console.log('seeking forward!')
            });
        }, 50000);

        setTimeout(function(){
            console.log('decreasing subtitles size...')
            device.changeSubtitlesSize(1, function(err, status){
                if(err) console.log("error...")
                console.log("subtitles size decreased.")
            });
        }, 60000);

        setTimeout(function(){
            device.pause(function(){
                console.log('Paused!')
            });
        }, 70000);

        setTimeout(function(){
            device.seek(30,function(){
                console.log('seeking forward!')
            });
        }, 80000);

        setTimeout(function(){
            device.seek(30,function(){
                console.log('seeking forward!')
            });
        }, 85000);

        setTimeout(function(){
            device.unpause(function(){
                console.log('unpaused!')
            });
        }, 90000);


        setTimeout(function(){
            device.seek(-30,function(){
                console.log('seeking backwards!')
            });
        }, 100000);


        setTimeout(function(){
            device.stop(function(){
                console.log('Stoped!')
            });
        }, 200000);

    })
  })
}
{% endhighlight %}

En definitiva, para muchas aplicaciones este módulo es más que suficiente. En caso de que queramos llevar un juego a Chromecast la cosa se complica. Tenemos que programar una app del tipo CustomMediaReceiver en HTML5 y luego su cliente (en Node.js o usando las librerías oficiales de Google para Android, iOS y Chrome). Si os ha gustado esta entrada y queréis saber como realizar esto último, compartid y comentad, me gustaría saber que opináis al respecto y podéis darme ideas.

