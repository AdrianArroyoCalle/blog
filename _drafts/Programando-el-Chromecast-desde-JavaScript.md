---
layout: post
title: Programando el Chromecast desde JavaScript
---

Chromecast (o Google Cast) es un dongle, un pequeño aparato, que se conecta a una entrada HDMI y permite disfrutar de contenido multimedia a un precio bastante ajustado (35$). Oficialmente solo se puede programar usando los SDK de iOS, Android y Chrome pero la comunidad ha conseguido replicar el protocolo interno. Chromecast ha tenido varios protocolos de comunicación pero el importante para lo que vamos a realizar se llama CASTv2.

Primero voy a explicar como funciona el Chromecast. Una app se conecta a Chromecast a través del protocolo de descubrimiento, deben estar en la misma red Wi-Fi. La aplicación solicita iniciar una aplicación, manda su ID. Chromecast busca en la base de datos de Google (https://cast.Google.com, tasa de registro de 5$) y allí le indicará una URL.

Chromecast abre la web y ejecuta la aplicación, que usando una librería de JavaScript le permite comunicarse con la app original. Podemos distinguir sin embargo varias aplicaciones "preinstaladas". Son webs como el resto pero están alojadas por Google sin marca. Son DefaultMediaReceiver y StyledMediaReceiver. Se trata de dos reproductores multimedia básicos, que soportan vídeo en MP4 y WebM desde una URL, subtítulos, carátula y en el caso de StyledMediaReceiver es posible modificar un poco el aspecto del reproductor. Veamos como llamar a esta aplicación desde Node.js.

