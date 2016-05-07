---
layout: post
title: ¿Qué ocurrirá con Bitcoin y los ordenadores cuánticos?
description: La irrupción de los ordenadores cuánticos pueden suponer un grave problema para la red Bitcoin y Ethereum.
date: "2016-05-07 16:40:00"
keywords:
 - programacion
 - bitcoin
 - linux
 - ubuntu
 - blogstack
 - cuantico
 - dwave
 - pregunta
---

Hay un tema que me preocupa desde hace un tiempo. Por un lado el auge de las criptodivisas como Bitcoin. Por otra parte, cada vez está más cerca la computación cuántica. Uno de los posibles usos de estos nuevos ordenadores será saltarse los sistemas de criptografía convencional. Así que me surge un dilema, ¿qué ocurrirá exactamente? ¿Habrá una crisis en el mundo Bitcoin?

La computación cuántica es inevitable. Ya vemos como Google y NASA están trabajando conjuntamente en modelos como [D-Wave 2](http://www.xataka.com/investigacion/el-ordenador-cuantico-d-wave-2-de-google-no-siempre-es-tan-potente) (aunque este modelo está pensado para Machine Learning no para criptografía). Así que si partimos de que la computación cuántica va a llegar, solo queda estar preparados para cuando el salto ocurra, que creo que será dentro de poco.

En [StackExchange Bitcoin](http://bitcoin.stackexchange.com/questions/6062/what-effects-would-a-scalable-quantum-computer-have-on-bitcoin) plantean esta pregunta

![Bitcoin StackExchange]({{ site.img }}/bitcoin-stackexchange.png)

Los ordenadores cuánticos afectarán a parte de la estructura Bitcoin.

El algoritmo ECDSA estará roto. Los ordenadores cuánticos encontrarán una manera sencilla de sacar la clave privada a partir de una clave pública. Significa que podrán acceder a tu cuenta con Bitcoins. Pero no es tan grave si se modifica el uso que le damos a Bitcoin y usamos las direcciones una única vez. La clave pública solo se envía cuando ya hemos gastado los Bitcoins así que si no reutilizamos la dirección nadie podrá acceder a tus Bitcoins.

Otro problema es el tema de los hashes. Actualmente se usa SHA256, el cuál es lo suficientemente seguro en computación tradicinal aunque con la potencia que tendrá la computación cuántica sería similar a descifrar SHA128 en un ordenador tradicional (algoritmo de Grove). En ese caso Bitcoin tiene un procedimiento para reemplazar el algoritmo rápidamente por un nuevo algoritmo diseñado con ordenadores cuánticos en mente que actualmente [están en desarrollo](https://en.wikipedia.org/wiki/Post-quantum_cryptography).

Pero lo que puede que además ocurra sea una hiperinflación, una centralización de la red. Puesto que en cuanto un ordenador cuántico entre en la red a minar, la dificultad aumentará drásticamente y el resto de mineros no podrán competir. El problema de la centralización lleva acarreado un problema de pérdida de confianza en la red ("si solo unos pocos controlan la red, ¿cómo sé que no están compinchados entre ellos?"). Si superan el 51% de la potencia de la red, pueden controlar toda la red. Podrá realizar transacciones inversas que él haya mandado. Puede bloquear las transacciones de tener confirmaciones. Puede bloquear al resto de mineros de minar un bloque válido que la red acepte.

El atacante no podrá, sin embargo, revertir las transacciones de otras personas, bloquear las transacciones (pueden tener 0 confirmaciones pero aparecerás), generar monedas por arte de magia, enviar monedas que nunca le han pertenecido. Así que en la mayoría de casos no sería tan rentable y en muchos casos lo que más dinero te de sea seguir las normas.

Conclusión, los ordenadores cuánticos pueden afectar a Bitcoin pero ya hay soluciones en marcha y no serán muy difíciles de implementar llegado el momento. Además el atacante podría no tener interés en llevar a cabo dicha acción pues el gasto que le llevaría seguiría siendo superior a lo que obtendría.

¿Qué opinas tú? ¿Crees que me he equivocado en algo?

Fuentes: 
* [http://bitcoin.stackexchange.com/questions/6062/what-effects-would-a-scalable-quantum-computer-have-on-bitcoin](http://bitcoin.stackexchange.com/questions/6062/what-effects-would-a-scalable-quantum-computer-have-on-bitcoin)
* [http://bitcoin.stackexchange.com/questions/10323/how-vulnerable-is-bitcoin-to-quantum-algorithms?lq=1](http://bitcoin.stackexchange.com/questions/10323/how-vulnerable-is-bitcoin-to-quantum-algorithms?lq=1)
* [https://bitcointalk.org/index.php?topic=133425.0](https://bitcointalk.org/index.php?topic=133425.0)
* [https://www.quora.com/What-will-quantum-computing-such-as-D-Wave-do-to-bitcoin-mining](https://www.quora.com/What-will-quantum-computing-such-as-D-Wave-do-to-bitcoin-mining)
* [https://bitcoinmagazine.com/articles/bitcoin-is-not-quantum-safe-and-how-we-can-fix-1375242150](https://bitcoinmagazine.com/articles/bitcoin-is-not-quantum-safe-and-how-we-can-fix-1375242150)
