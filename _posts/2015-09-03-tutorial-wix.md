---
layout: post
title: Tutorial de WiX (Windows Installer MSI)
description: Tutorial para generar instaladores MSI de la plataforma Windows Installer usando WiX
keywords:
 - wix
 - tutorial
 - programacion
 - instalador
 - windows
 - microsoft
 - xml
 - blogstack
---

Siguiendo la estela del [tutorial de CMake]({% post_url 2015-06-22-tutorial-de-cmake %}) hoy traigo el tutorial de WiX.

## ¿Qué es WiX?

WiX es un proyecto opensource destinado a producir instaladores de la plataforma Windows Installer. Windows Installer es la plataforma de instalaciones preferida por Microsoft desde que comenzó su desarrollo en 1999. Los archivos MSI son los instaladores genéricos que usa Windows Installer. Provee de un entorno más seguro para modificar el sistema al de un EXE tradicional por el hecho de que Windows Installer es declarativo, no imperativo. Windows Installer es transaccional, facilita el despliegue en entornos empresariales, tiene APIs (Windows Installer API y Windows Installer SDK), permite la localización de manera sencilla, la validación de instalaciones y la gestión de reinicios. Tiene los siguientes inconvenientes: es complejo, los accesos directos, su línea de comandos, su uso del registro y sus herramientas. Así pues con WiX podemos crear paquetes MSI de Windows Installer con unos ficheros XML donde definimos la instalación.

![Esquema de Windows Installer]({{ site.baseurl }}images/WindowsInstaller.png)

También conviene diferenciar los diferentes tipos de archivos que soporta Windows Installer

|Extensión|Función|
|---------|-------|
| MSI | Instalador convencional |
| MSM | Módulo de fusión |
| MSP | Módulo de parche |
| MST | Módulo de transformación |

No hay que confundir estos archivos con los MSU, también usados por Microsoft pero para Windows Update y cuya estructura es diferente.


## Instalando WiX

Para instalar WiX podemos usar Chocolatey. Abrimos PowerShell como administrador y ejecutamos.

```
choco install -y wixtoolset
```

Si queremos añadir las herramientas al PATH, en PowerShell.

```
$PATH = [Environment]::GetEnvironmentVariable("PATH")
$WIX_BIN = "C:\Program Files (x86)\WiX Toolset v3.9\bin"
[Environment]::SetEnvironmentVariable("PATH","$PATH;$WIX_BIN")
```

## Herramientas

WiX viene con un conjunto de herramientas diseñadas para trabajar con Windows Installer.

|Nombre|Función|
|------|-------|
|candle.exe|Compila los archivos .wxs y .wxi para generar archivos objeto .wixobj|
|light.exe|Enlaza los objetos .wixobj y .wixlib produciendo el .msi|
|lit.exe| Permite unir archivos .wixobj en una librería .wixlib|
|dark.exe| Convierte un archivo ya compilado en código fuente WiX |
|heat.exe| Podemos añadir archivos al fichero WiX en masa, sin especificar manualmente |
|insignia.exe| Permite firmar archivos MSI con las mismas firmas que los CABs|
|melt.exe|Convierte un archivo MSM a un fichero código fuente de WiX|
|torch.exe| Extrae las diferencias entre objetos WiX para generar una transformación. Usado para generar parches. |
|smoke.exe| Valida ficheros MSI o MSM|
|pyro.exe|Genera un fichero de parches MSP|
|WixCop.exe|Recomienda estándares en los ficheros WiX|
|WixUnit.exe|Realiza una validación a los ficheros WiX|
|lux.exe|Usado para tests unitarios|
|nit.exe|Usado para tests unitarios|

> _Nota: Vamos a necesitar generar GUIDs. En PowerShell podeis usar `[GUID]::NewGuid()` o `[GUID]::NewGuid().ToString()`. Si teneis instalado Visual Studio, también está disponible `uuidgen`_

## El fichero .wxs

El fichero WXS es la base de WiX y es un fichero XML. Para el ejemplo voy a empaquetar [Lumtumo](http://bitbucket.org/AdrianArroyoCalle/lumtumo). Lumtumo contiene un ejecutable, varias DLL y varios archivos como imágenes y fuentes que están distribuidos por carpetas. He depositado la carpeta con los binarios y todos lo necesario en SourceDir.

{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<!-- Variables del preprocesador -->
<?define Platform = x86 ?>
<?if $(var.Platform) = x64 ?>
<?define ProductName = "Lumtumo (64 bit)" ?>
<?define Win64 = "yes" ?>
<?define PlatformProgramFilesFolder = "ProgramFiles64Folder" ?>
<?else ?>
<?define ProductName = "Lumtumo" ?>
<?define Win64 = "no" ?>
<?define PlatformProgramFilesFolder = "ProgramFilesFolder" ?>
<?endif ?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
	<!-- Códigos de idioma https://msdn.microsoft.com/en-us/library/Aa369771.aspx -->
	<Product Name="Lumtumo" Manufacturer="Adrian Arroyo Calle" Id="BAE7D874-3177-46A6-BB2D-043EFF8C59F2" UpgradeCode="457861BD-A051-4150-8752-82907E7BAF19" Language="1033" Codepage="1252" Version="1.0">
   <!-- Nunca, NUNCA, se debe cambiar el valor de UpgradeCode. Es el identificador que distingue a los productos entre versiones -->
    <Package Description="$(var.ProductName)" Platform="$(var.Platform)" Keywords="Game" Id="*" Compressed="yes" InstallScope="perMachine" InstallerVersion="300" Languages="1033" SummaryCodepage="1252" Comments="Space invaders redefined" Manufacturer="Adrian Arroyo Calle"/>
	  <!-- Generamos el listado de ficheros a instalar con heat.exe dir ..\..\build\Release\ -dr LumtumoDir -cg LumtumoComponent -gg -g1 -sf -srd -out files.wxs -->
    <!-- Es necesario actualizar Shortcut/@Target cada vez que usemos Heat para conservar la referencia al ejecutable principal válida -->
    <!-- Instalar con msiexec /i lumtumo.msi , desinstalar con msiexec /x lumtumo.msi-->
    
        <MajorUpgrade DowngradeErrorMessage="A later version of Lumtumo is already installed. Setup will now exit."/>
    <!-- Gestiona las actualizaciones posteriores. Estos MSI de actualización deben tener igual UpgradeCode, distinto Id y una versión superior-->

    <Icon Id="icon.ico" SourceFile="SourceDir/Lumtumo.exe"/>
    <!-- El icono puede estar en un ejecutable -->
    <Property Id="ARPPRODUCTICON" Value="icon.ico" />
    <!-- Este es el icono del panel de control -->
    <Property Id="ARPHELPLINK" Value="http://adrianarroyocalle.github.io" />
    <!-- Enlace de ayuda para el panel de control. Hay más propiedades con enlaces para el panel de control-->

    <MediaTemplate CabinetTemplate="LUM{0}.cab" CompressionLevel="high" EmbedCab="yes"/>
    <!-- WiX se encargará de generar los archivos Cabinet necesarios. Esto será cuando llamemos a light.exe -->
    
    <Feature Id="ProductFeature" Title="Game" Level="1">
      <ComponentGroupRef Id="LumtumoComponent"/>
      <ComponentRef Id="ApplicationShortcut" />
    </Feature>

    <!-- Solo hay una funcionalidad, el juego completo. Esta incluye todos los archivos de Lumtumo y además el acceso directo en el menú de Inicio. LumtumoComponent está definido en files.wxs -->

    <Directory Id='TARGETDIR' Name='SourceDir'>
      <Directory Id='$(var.PlatformProgramFilesFolder)'>
        <Directory Id="LumtumoDir" Name='Lumtumo'>
        </Directory>
      </Directory>
      <Directory Id="ProgramMenuFolder">
        <Directory Id="ApplicationProgramsFolder" Name="Lumtumo"/>
      </Directory>
    </Directory>
    <!-- La estructura de carpetas básica. TARGETDIR debe ser el ROOT siempre. Además, ProgramFilesFolder (en este caso usamos el preprocesador antes) y ProgramMenuFolder ya están definidos por Windows. Así que realmente creamos LumtumoDir (que usa files.wxs) y ApplicationProgramsFolder (justo abajo trabajamos con esa carpeta). Ambas se crean con el nombre de Lumtumo en el sistema de archivos -->

    <DirectoryRef Id="ApplicationProgramsFolder">
      <Component Id="ApplicationShortcut" Guid="03466DA8-7C3F-485E-85E6-D892E9F7FFE4">
        <Shortcut Id="ApplicationStartMenuShortcut"
                  Name="Lumtumo"
                  Description="Space Invaders redefined"
                  Target="[#fil7BBA1E2E293173E87EC3F765BF048B16]" Icon="icon.ico"
                  WorkingDirectory="LumtumoDir"/>
        <RemoveFolder Id="ApplicationProgramsFolder" On="uninstall"/>
        <!-- Nos aseguramos de borrar la carpeta con el acceso directo al desinstalar-->
        <RegistryValue Root="HKCU" Key="Software\Microsoft\Lumtumo" Name="installed" Type="integer" Value="1" KeyPath="yes"/>
        <!-- Con esta llave del registro apareceremos en el panel de control para ser desinstalados-->
      </Component>
    </DirectoryRef>

    <Condition Message='This application only runs on Windows NT'>
      VersionNT
    </Condition>
    <!-- Un ejemplo de condiciones. En este caso pedimos que Windows tenga el núcleo NT. Se pueden especificar rangos de versiones de Windows e incluso las ediciones. Las condiciones se pueden aplicar a componentes específicos también-->
    
  </Product>
</Wix>
{% endhighlight %}

Ahora se genera el archivo MSI

```
heat.exe dir SourceDir -dr LumtumoDir -cg LumtumoComponent -gg -g1 -sf -srd -out files.wxs
# Editamos el archivo Lumtumo.wxs para actualizar la referencia al ejecutable principal en el acceso directo
candle.exe files.wxs
candle.exe Lumtumo.wxs
light.exe files.wixobj Lumtumo.wixobj -out lumtumo.msi
```


Este ejemplo básico está muy bien, instala todo, añade un icono en el menú de inicio (también se puede poner en el escritorio pero no me gusta), se integra con el panel de control para hacer una desinstalación limpia e incluso con modificar un valor podemos generar el paquete para 64 bits. Sin embargo faltan cosas. No se puede especificar la carpeta de instalación, de hecho, el MSI no muestra ninguna opción al usuario al instalarse. Para introducir GUI en WiX tenemos que usar la librería WiXUI.

## WixUI

Para usar WixUI tenemos que cambiar el comando que usamos para llamar a light

```
light.exe -ext WixUIExtension files.wixobj Lumtumo.wixobj -out lumtumo.msi
```

Con esto ya podemos usar la librería WixUI. La manera más básica de añadir una GUI es introducir la GUI Minimal. Al final de la etiqueta Product podemos insertar

{% highlight xml %}
    <WixVariable Id="WixUILicenseRtf" Value="LICENSE.rtf" />
    <UIRef Id="WixUI_Minimal" />
    <UIRef Id="WixUI_ErrorProgressText" />
{% endhighlight %}

Y LICENSE.rtf en un archivo que tenemos junto a los ficheros WXS.

Si queremos un buen resultado visualmente hablando toca diseñar dos ficheros BMP.

```
<WixVariable Id="WixUIBannerBmp" Value="path\banner.bmp" /> <!-- 493x58 -->
<WixVariable Id="WixUIDialogBmp" Value="path\dialog.bmp" /> <!-- 493x312 -->
```

Aquí uso la interfaz Minimal que lo único que hace es pedir aceptar la licencia e instalarse tal como habíamos visto antes. Hay más interfaces: WixUI_Mondo, WixUI_FeatureTree, WixUI_InstallDir y WixUI_Advanced. Todas ellas permiten más ajustes que WixUI_Minimal. También podemos crear ventanas personalizadas pero en mi opinión es algo a evitar. Las instalaciones deben ser lo más simples posibles y dejar a la aplicación en sí toda la configuración que necesite. Respecto a cambiar el directorio de instalación, no soy partidario pero si quereis la cuestión es sustituir LumtumoDir por INSTALLDIR (en hate.exe y en el fichero Lumtumo.wxs) y en la etiqueta Feature añadir `Display="expand" ConfigurableDirectory="INSTALLDIR"`

## Bundle y Bootstrap

Un archivo MSI está bien pero quizá nos gusté más un EXE que además instale las dependencias.

{% highlight xml %}
<?xml version="1.0" encoding="utf-8"?>
<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
  <Bundle Name="Lumtumo" Version="1.0" Manufacturer="Adrián Arroyo Calle" UpgradeCode="AC44218D-B783-4DF9-B441-5AE54394DAA9" AboutUrl="http://adrianarroyocalle.github.io">
    <!-- <BootstrapperApplicationRef Id="WixStandardBootstrapperApplication.RtfLicense" /> -->
    <BootstrapperApplicationRef Id="WixStandardBootstrapperApplication.HyperlinkLicense">
      <bal:WixStandardBootstrapperApplication LicenseUrl="" xmlns:bal="http://schemas.microsoft.com/wix/BalExtension"/>
    </BootstrapperApplicationRef>

    <Chain>
      <ExePackage Id="Dependency1" SourceFile="Dependency_package_1.exe" />
      <ExePackage Id="Dependency2" SourceFile="Dependency_package_2.exe" />

      <RollbackBoundary Id="RollBack" />

      <MsiPackage Id="MainPackage" SourceFile="lumtumo.msi" Vital="yes" />
    </Chain>
  </Bundle>
</Wix>
{% endhighlight %}

Y compilamos

```
candle.exe setup.wxs
light.exe -ext WixBalExtension setup.wxs
```

Y se genera el archivo `setup.exe`. Por defecto el archivo MSI se instala en modo silencioso por lo que la GUI pasa a ser la de Bootstrap.

## Más sintaxis WiX

### Registrar un tipo de archivo

{% highlight xml %}
<ProgId Id='ACME.xyzfile' Description='Acme Foobar data file' Icon="icon.ico">
    <Extension Id='xyz' ContentType='application/xyz'>
        <Verb Id='open' Command='Open' TargetFile='[#ID_DE_EJECUTABLE]' Argument='"%1"' />
    </Extension>
</ProgId>
{% endhighlight %}

### Escribir configuración en archivo INI

{% highlight xml %}
<IniFile Id="WriteIntoIniFile" Action="addLine" Key="InstallDir" Name="Foobar.ini" Section="Paths" Value="[INSTALLDIR]" />
{% endhighlight %}

### Escribir en el registro

{% highlight xml %}
<RegistryKey Id='FoobarRegInstallDir' Root='HKLM' Key='Software\Acme\Foobar 1.0' Action='createAndRemoveOnUninstall'>
    <RegistryValue Type='string' Name='InstallDir' Value='[INSTALLDIR]'/>
    <RegistryValue Type='integer' Name='Flag' Value='0'/>
</RegistryKey>
{% endhighlight %}

### Borrar archivos extra en la desinstalación

{% highlight xml %}
<RemoveFile Id='LogFile' On='uninstall' Name='Foobar10User.log' />
<RemoveFolder Id='LogFolder' On='uninstall' />
{% endhighlight %}

