---
layout: post
title: SmartOS, una introducción
description: SmartOS es un sistema operativo basado en el kernel illumos y desarrollado por Joyent
keywords:
 - smartos
 - solaris
 - unix
 - smartmachine
 - virtualizacion
 - sistema-operativo
 - illumos
 - introduccion
---

Hoy vamos a probar [SmartOS]. SmartOS es el sistema operativo de Joyent para aplicaciones cloud. Usa un kernel [illumos] (fork de OpenSolaris cuando Oracle cerró el proyecto, a nivel técnico comparte mucho con Solaris 10) y usa extensivamente características únicas de Solaris. Además, es el único illumos que tiene KVM, una característica de Linux para permitir virtualización de alto rendimiento.

# Descargando SmartOS

Lo primero que tenemos que hacer para probar SmartOS es descargarlo. Lo podemos descargar desde [SmartOS.org](http://smartos.org). Allí encontraremos un enlace a la wiki donde está alojada la descarga. En SmartOS no se habla de versiones, hay versiones nuevas cada 2 semanas y se identifican las descargas con las fechas. La descarga está disponible en varios formatos. El formato recomendado es USB, pero para este post vamos a descargar la imagen de VMware. La descarga no es muy grande (~250 MB) y cuando lo tengamos lo descomprimimos en alguna carpeta. Abrimos [VMware Player] (o VMware Fusion o VMware Workstation, el que te guste más) y desde allí abrimos la máquina virtual. Nos preguntará que si la hemos movido o copiado. Decimos que la hemos copiado. Ahora tenemos que arrancarla. Antes de nada comprueba que tu ordenador puede ejecutar máquinas virtuales de 64 bits, ya que SmartOS solo es de 64 bits. Una vez lo hemos arrancado nos aparecerá una imagen de GRUB. Seleccionamos la primero opción _Live 64-bit (text)_. Si tienes experiencia instalando sistemas operativos verás que aquí no hay ninguna entrada para instalar. Esto es porque SmartOS no se instala, se configura.

# Configurando SmartOS

Ahora nos saldrá un asistente con una serie de preguntas. Respondemos a ellas. En el tema de la conexión yo elegí DHCP y tenía configurada la máquina virtual para conectarse usando NAT. En el apartado de discos destacar que solo podemos seleccionar el último. Si elegimos el primer disco que se nos ofrece estaremos sobreescribiendo la imagen Live de SmartOS y la suiente vez no arrancará. Cuando hayan terminado las preguntas se reiniciará y en GRUB seleccionamos la misma opción. Ahora veremos un curioso login con el símbolo de Joyent. En este momento el sistema ya está configurado para empezar a trabajar dentro de él. Podemos usar SSH o la terminal del ordenador.

# Creando la SmartMachine

Ahora vamos a crear una SmartMachine. ¿Qué es una SmartMachine? Es una zona dentro de SmartOS autocontenida que no puede interactuar con el exterior. Es una manera de virtualización que ofrece SmartOS (la otra es [KVM]). En las SmartMachines será el único lugar donde podremos instalar software (realmente sí se puede instalar fuera de una zone con un instalador manual, pero no es recomendable). Bien, ahora debemos actualizar la lista de imágenes base para las SmartMachines.

```
imgadm update
```

Ahora buscamos la que más se adecue a lo que buscamos.

```
imgadm avail
```

En mi caso buscaba algo que tuviese ya Node.js e hice esto.

```
imgadm avail | grep node
```

Y la descargamos con

```
imgadm import UUID_DE_LA_IMAGEN
```

Es importante ver que en [SmartOS] el uso de los UUID está muy presente como veremos

Ahora que ya tenemos la base vamos a definir nuestra SmartMachine mejor. Así pues creamos un fichero JSON tal que así. Yo lo he decidido guardar en /tmp/node-zone.json

{% highlight js %}
{
    "brand" : "joyent",
    "dataset_uuid": "NUESTRO_UUID",
    "resolvers" : ["8.8.8.8"],
    "nics" : [
    	"nic_tag" : "dhcp",
        "ip" : "dhcp"
    ],
    "autoboot" : true,
    "ram" : 512
}
{% endhighlight %}

Y en hay muchísimas más opciones. Puedes verlas todas en el manual de vmadm

```
man vmadm
```

Ahora creamos una nueva zone basada en nuestra imagen base con:

```
vmadm create -f /tmp/node-zone.json
```

Ahora podemos encontrar las zonas que estan activas:

```
zoneadm list -civ
```

Como vemos hay dos zonas activas, una es la global, en la que estamos trabajando. La otra es la que acabamos de crear y que tiene un nuevo UUID asignado. Mencionar que las zonas las podemos encender y apagar con vmadm también:

```
vmadm stop UUID && vmadm start UUID
```

Bien, para entrar a las zonas podemos hacerlo con zlogin

```
zlogin UUID
```

y estaremos dentro de una zona. En mi caso se puede comprobar que ya tengo Node.js instalado con

```
node -v && npm -v
```
# Dentro de la SmartMachine

Ahora podemos instalar paquetes para la zona con pkgin. Por ejemplo digamos que quiero instalar [CMake].

```
pkgin update && pkgin install cmake
```

Ahora debemos ajustar todo para la aplicación que deseemos probar. Una buena manera para empezar sería clonar un repositorio Git en la carpeta dentro del usuario de la carpeta /home. Luego instalaríamos todo con

```
npm install
```

Ahora crearemos el servicio. Creamos un fichero XML parecido a este:
{% highlight xml %}
<?xml version="1.0"?>
<!DOCTYPE service_bundle SYSTEM "/usr/share/lib/xml/dtd/service_bundle.dtd.1">
<service_bundle type="manifest" name="sonzono">
  <service name="site/sonzono" type="service" version="1">

    <create_default_instance enabled="true"/>

    <single_instance/>

    <dependency name="network" grouping="require_all" restart_on="refresh" type="service">
      <service_fmri value="svc:/milestone/network:default"/>
    </dependency>

    <dependency name="filesystem" grouping="require_all" restart_on="refresh" type="service">
      <service_fmri value="svc:/system/filesystem/local"/>
    </dependency>

    <method_context working_directory="/home/admin/sonzono">
      <method_credential user="admin" group="staff" privileges='basic,net_privaddr'  />
      <method_environment>
        <envvar name="PATH" value="/home/admin/local/bin:/usr/local/bin:/usr/bin:/usr/sbin:/bin"/>
        <envvar name="HOME" value="/home/admin"/>
      </method_environment>
    </method_context>

    <exec_method
      type="method"
      name="start"
      exec="/opt/local/bin/node /home/admin/sonzono/app.js"
      timeout_seconds="60"/>

    <exec_method
      type="method"
      name="stop"
      exec=":kill"
      timeout_seconds="60"/>

    <property_group name="startd" type="framework">
      <propval name="duration" type="astring" value="child"/>
      <propval name="ignore_error" type="astring" value="core,signal"/>
    </property_group>

    <property_group name="application" type="application">

    </property_group>


    <stability value="Evolving"/>

    <template>
      <common_name>
        <loctext xml:lang="C">node.js sonzono</loctext>
      </common_name>
    </template>
  </service>
</service_bundle>
{% endhighlight %}

Lo guardamos dentro de la configuración con.

```
svccfg import sonzono.xml
```

Y ya podemos activar el servicio

```
svcadm enable sonzono
```

Podemos ver los logs de todos los servicios en /var/svc/log/

Y con esto creo que ya teneis suficiente información acerca de [SmartOS] como para ir jugueteando con él. Quiero mencionar que [SmartOS] es un sistema operativo con muy poco soporte pero que poco a poco se va haciendo más importante.

# Referencias
[SmartOS]: http://smartos.org
[CMake]: http://cmake.org
[KVM]: http://es.wikipedia.org/wiki/Kernel-based_Virtual_Machine
[VMware Player]: https://my.vmware.com/web/vmware/free
[illumos]: http://wiki.illumos.org/display/illumos/illumos+Home
[https://github.com/isaacs/joyent-node-on-smart-example](https://github.com/isaacs/joyent-node-on-smart-example)

[http://docs.instantservers.telefonica.com/display/isc2/Developing+a+Node.js+Application](http://docs.instantservers.telefonica.com/display/isc2/Developing+a+Node.js+Application)

[http://wiki.smartos.org/display/DOC/How+to+create+a+zone+%28+OS+virtualized+machine+%29+in+SmartOS](http://wiki.smartos.org/display/DOC/How+to+create+a+zone+%28+OS+virtualized+machine+%29+in+SmartOS)

[http://www.machine-unix.com/beginning-with-smartos/](http://www.machine-unix.com/beginning-with-smartos/)
