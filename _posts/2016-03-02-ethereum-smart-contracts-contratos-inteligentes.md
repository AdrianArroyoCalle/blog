---
layout: post
title: Ethereum y SmartContracts
description:
keywords:
 - programacion 
 - blogstack
 - ethereum
 - bitcoin
 - linux
 - ubuntu
 - codius
 - smartcontracts
---

En estos últimos años han surgido toda una marea tecnológica siguiendo los principios de la cadena de bloques (blockchain en inglés) popularizada por Bitcoin. En un principio se extendieron las criptodivisas usando esta tecnología, las llamadas altcoins. Algunas se han vuelto muy famosas como Litecoin, Dogecoin, Ripple, Feathercoin, StartCoin, ReddCoin, Dash o incluso un intento de criptodivisa española, la PesetaCoin.

Si revisamos la lista de criptodivisas por capitalización de mercado en [CoinMarketCap.com](https://coinmarketcap.com/) veremos que en el puesto número aparece una que no he mencionado, se trata de Ethereum. Pero no adelantemos acontecimientos.

![Capitalización de mercado de las criptodivisas]({{ site.baseurl }}images/CoinMarketCap.png)

Hemos dicho que la tecnología de la cadena de bloques se ha usado para diseñar criptodivisas. Sin embergo, recientemente ha aparecido una nueva aplicación de esta tecnología. Los contratos inteligentes (o Smart Contracts).

## ¿Qué son los contratos inteligentes?

Podemos definir los contratos inteligentes como un tipo de aplicación informática que se encargan de ejecutar una cierta acción si se cumple la condición especificada. Podemos pensar en ellos como un contrato con cláusulas específicas según la casuística. Los contratos inteligentes además serían fácilmente verificables y a su vez seguros. La idea es que dadas unas condiciones, se ejecuten las acciones especificadas, sin ninguna excepción. El concepto de los contratos inteligentes surgió de manos de [Nick Szabo](http://szabo.best.vwh.net/smart_contracts_idea.html) en la década de los noventa. Y ahora ya tenemos la primera implementación de aquellas ideas en [Ethereum](https://www.ethereum.org/). Un ejemplo muy sencillo de contrato inteligente es una apuesta con un amigo en un partido de fútbol, cada uno apuesta por un equipo y deposita el dinero en el contrato. Cuando el partido haya finalizado el contrato ejecutará la cláusula correspondiente y enviará al dinero al afortunado.

## ¿Qué es Ethereum?

> _Si piensas en el Bitcoin como una hoja de cálculo global, piensa en Ethereum como un sistema operativo global_

![Ethereum Frontier]({{ site.baseurl }}images/EthereumFrontier.png)

Ethereum es una implementación de los smart contracts basada en la cadena de bloques. Es descentralizado, como Bitcoin. Los aplicaciones (los contratos inteligentes) en Ethereum se ejecutan sin nisiquiera la posibilidad de caída de la red, censura, fraude o intervención de terceras partes. Los contratos inteligentes simplemente se ejecutan, es __imposible__ que no se ejecuten. Esa es la gran ventaja de Ethereum respecto al Internet como lo conocíamos antes.

Las aplicaciones en Ethereum se suben a la cadena de bloques y se ejecutan bajo demanda, con una potencia no muy elevada (piensa en un smartphone de 1999) pero con una cantidad de memoria y una capacidad de almacenamiento permanente ilimitados. Eso no significa que cualquiera pueda hacer lo que quiera con un programa, pues los contratos pueden estar diseñados para ignorar las peticiones hechas desde usuarios desconocidos. En último término, el objetivo de Ethereum es proveer una computación 100% determinista.

![Ethereum Logo]({{ site.baseurl}}images/EthereumLogo.png)

## ¿Cómo funciona?

Usar Ethereum no es gratis, el sistema operativo global necesita _combustible_. Ese combustible es Ether, aunque en muchos sitios se le llama directamente Ethereum por estar ligado a la plataforma. Ether es una criptodivisa al estilo Bitcoin, pero se puede gastar directamente en ejecutar contratos inteligentes en Ethereum. Al igual que en Bitcoin, en Ethereum hay mineros, que ejecutan los contratos para comprobar que todos obtienen el mismo resultado. Esos mineros reciben su recompensa en Ether que pueden usar o vender en sitios como [ShapeShift](https://shapeshift.io/).

Además necesitaremos un cliente para subir y pedir la ejecución de los contratos inteligentes. Hay muchos, voy a hablar de los cuatro más importantes.:

* Eth: el cliente en C++
* Geth: el cliente en Go (recomendado)
* Web3.js: una unión entre el navegador y Ethereum usando la interfaz RPC de otro cliente Ethereum
* Mist: se trata de un navegador basado en Electrum (o sea, Chromium) que integra las funciones de Ethereum. Podemos interactuar con las DApps directamente si usamos este navegador. Veremos que son las DApps más adelante.

Desde Geth podemos sincronizarnos con la red Ethereum, minar para ganar Ether, ejecutar contratos en la red y subirlos.

Podemos ver como se ejecuta un contrato inteligente en acción en [EtherDice](https://etherdice.io/), un simple juego de apuestas con dado.

```
eth.sendTransaction({from: eth.accounts[0], value: web3.toWei(1, 'ether'), to: '0x2faa316fc4624ec39adc2ef7b5301124cfb68777', gas: 500000})
```

Esta orden se introduce dentro de Geth. Básicamente está realizando un traspaso de fondos desde nuestra cuenta principal (eth.accounts[0], aunque se puede especificar otra si nos sabemos la dirección), el valor de la transacción que es la cantidad de Ether a traspasar. Ether tiene muchos submúltiplos, en este caso usa el Wei. 1 ether = 1000000000000000000 wei. Se especifica la dirección de destino y además el máximo de gas que estaríamos dispuesto a perder en la ejecución (no es posible cuanto va a costar una ejecución). Este valor máximo es el producto del gas por el precio del gas y representa el tope de weis que puede consumir el contrato antes de que se cancele. Con contratos muy probados valdría cualquier valor, pero si estás desarrollando un contrato de vendrá muy bien para que una programación errónea no liquide todos tus fondos antes de tiempo.

Bien, este ejemplo es muy sencillo. De manera más genérica usaríamos la función __eth.contract__

```
var greeter = eth.contract(ABI).at(Direccion);
greeter.greet(VALORES DE INPUT,{from: TuDireccion, gas: 50000});
```

Siendo la ABI la definición de la interfaz para poder interactuar con el contrato y la dirección es donde reside el contrato en sí. Luego llamamos a la función greet dentro del contrato, puede aceptar parámetros de entrada. Todo esto esta muy bien pero no hemos visto como son realmente los contratos todavía. Un ejemplo muy bueno es [Etheria](http://etheria.world/)

![Etheria]({{ site.baseurl }}images/Etheria.png)

## Solidity y la máquina virtual

Los contratos se ejecutan en una máquina virtual llamada EVM (Ethereum Virtual Machine). Esta máquina virtual es Turing completa pero para evitar un colapso (bucles infinitos) tiene en cuenta el gas. Las operaciones en la EVM son lentas, porque cada contrato es ejecutado simultaneamente en el resto de nodos de la red, siendo el resultado final un resultado de consenso de la red. Se han diseñado varios lenguajes que compilan a EVM, pero sin duda el más popular es Solidity.

```
contract mortal {
    /* Define variable owner of the type address*/
    address owner;

    /* this function is executed at initialization and sets the owner of the contract */
    function mortal() { owner = msg.sender; }

    /* Function to recover the funds on the contract */
    function kill() { if (msg.sender == owner) suicide(owner); }
}

contract greeter is mortal {
    /* define variable greeting of the type string */
    string greeting;

    /* this runs when the contract is executed */
    function greeter(string _greeting) public {
        greeting = _greeting;
    }

    /* main function */
    function greet() constant returns (string) {
        return greeting;
    }
}
```

Este sería un ejemplo de Greeter en Solidity. No voy a explicar la programación en Solidity, ni como se inician los contratos. Si hay demanda popular explicaré como se suben los programas y se inicializan.

## DApps

Decentralized Apps, con la tecnología de Ethereum ha surgido un nuevo concepto. Aplicaciones web que se separan del concepto tradicional de cliente-servidor y se ejecutan de manera descentralizada. Estas aplicaciones, aunque siguen necesitando Internet pueden funcionar sin un servidor central si nuestro ordenador dispone de un nodo de Ethereum. Esto es precisamente lo que hace el navegador Mist. Otro aprovechamiento más tradicional de las DApps es dejar un servidor central que corra como nodo de Ethereum y tenga una IP asignada. Sin embargo este servidor central puede ser muy ligero, pues solo sirve de puerta de entrada a la red Ethereum. Este aprovechamiento funcionaría en navegadores tradicionales siempre que los gastos de la red corran a cuenta del administrador de la app. Un ejemplo de DApp que requiere usar el navegador Mist es [EthereumWall](http://ethereumwall.com/), la aplicación usa nuestros fondos para su funcionamiento y aunque tiene un servidor central estático para entregar los archivos HTML y el JavaScript, esto no sería necesario pues la lógica la hace la red Ethereum con nuestro nodo local en Mist.

![Navegador Mist]({{ site.baseurl }}images/Mist.jpg)


## Conclusión

¿Qué os parecen los contratos inteligentes? ¿Qué os parece la plataforma Ethereum? ¿Tendrá futuro o es una moda pasajera? ¿Crees que puede revolucionar la manera de pensar la web? Comenta, quiero saber tu opinión.

Para más información no dudes en consultar el sitio oficial de [Ethereum](https://www.ethereum.org) y [el libro oficial](https://ethereum.gitbooks.io)

Si crees que lo merece puedes enviarme: BTC(1A2j8CwiFEhQ4Uycsjhr3gQPbJxFk1LRmM), LTC(LXkefu8xYwyD7CcxWRfwHhSRTdk6Sp38Kt), DOGE(D7fvbHocEGS7PeexBV23ktWjgVL1y9RnoK), ReddCoin(RsHAsr6PVs8y4f5pGLS2cApcGpgw15TwUJ)
