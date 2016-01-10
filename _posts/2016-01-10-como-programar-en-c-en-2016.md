---
layout: post
title: ¿Cómo programar en C (en 2016)?
description: Revisión de pautas y buenas prácticas que debes seguir si escribes C en 2016. Artículo traducido.
keywords:
 - blogstack
 - programacion
 - linux
 - ubuntu
 - c
 - 2016
 - pautas
 - buenas-practicas
---

> _Este artículo es una traducción del artículo [How to C in 2016](http://matt.sh/howto-c). Todo el contenido aparece originalmente en aquel artículo, yo solo me he limitado a traducirlo._

![C]({{ site.baseurl }}images/c.jpg)

La primera regla de C es no escribir en C si puedes evitarlo.

Si te ves obligado a escribir en C, deberías seguir las reglas modernas.

C ha estado con nosotros desde principios de los 70. La gente a "aprendido C" en numerosos puntos de su evolución, pero el conocimiento normalmente se para después de aprender. Así pues todo el mundo piensa diferente sobre C según el año en que empezaron a aprenderlo.

Es importante no quedarse paralizado en las "cosas que aprendí en los 80/90" cuando programas en C.

Esta página asume que estás en una plataforma moderna, con estándares modernos y no tienes que mantener una compatibilidad con sistemas antiguos muy elevada. No debemos estar atados a estándares anticuados solo porque algunas compañías rechacen actualizar sistemas con más de 20 años de antigüedad.

## Preliminar

Standard C99 (C99 significa "Estándar C de 1999"; C11 significa "Estándar C de 2011", así que C11 > C99)

* clang, por defecto
  - C99 es la implementación de C por defecto en clang, no necesita opciones extra
    * Sin embargo esta implementación no es realmente estándar. Si quieres forzar el estándar, usa `-std=c99`
  - Si quieres usar C11, debes especificar `-std=c11`
  - clang compila el código fuente más rápidamente que gcc
* gcc necesita que especifiques `-std=c99` o `-std=c11`
  - gcc compila más lentamente pero _a veces_ genera ejecutables más rápidos
  - gcc-5 establece por defecto `-std=gnu11`, así que debes seguir especificando una versión estándar `c99` o `c11`.

Optimizaciones

* `-O2, -O3`
  - generalmente querrás `-O2`, pero algunas veces querrás `-O3`. Prueba tu código con ambos niveles (y entre distintos compiladores) y mantente con los ejecutables más eficientes y rápidos.
* `-Os`
  - `-Os` ayuda si te preocupa la eficiencia de la caché (que debería)

Advertencias

* `-Wall -Wextra -pedantic`
  - las nuevas versiones de los compiladores tienen `-Wpedantic`, pero todavía aceptan el antiguo `-pedantic` por cuestiones de compatibilidad.
  - durante las pruebas deberías añadir `-Werror` y `-Wshadow` en todas tus plataformas
    * puede ser peliagudo enviar a producción con `-Werror` porque cada plataforma y cada compilador y cada librería pueden emitir distintas advertencias. Probablemente no querrás terminar la compilación entera de un usuario porque su versión de GCC en una plataforma que nunca habías visto se queja de manera nueva y sorprendente.
  - algunas opciones más sofisticadas son `-Wstrict-overflow -fno-strict-aliasing`
    * especifica `-fno-strict-aliasing` o estate seguro de que solo accedes a los objetos con el tipo que tuvieron en su definición. Como mucho código en C ya existente se salta lo último es mucho más seguro usar `-fno-strict-aliasing` particularmente si no controlas todo el código que debes compilar.
  - ahora mismo, clang reporta alguna sintaxis válida como advertencia, así que debes añadir `-Wno-missing-field-initializers`
    * GCC resolvió este problema después de GCC 4.7

Compilando

* Unidades de compilación
  - La manera más común de compilar proyectos en C es generar un fichero objeto de cada fichero fuente y unirlo todos al final. Este procedimiento es muy bueno para el desarrollo incremental, pero no lo es para el rendimiento y la optimización. El compilador no puede detectar optimizaciones entre archivos con este método.
* LTO - Link Time Optimization
  - LTO arregla el problema de las unidades de compilación generando además una representación intermedia que puede ser sujeta de optimizaciones entre archivos. Este sistema ralentiza el tiempo de enlazado significativamente pero `make -j` puede ayudar.
  - [clang LTO](http://llvm.org/docs/LinkTimeOptimization.html) ([guía](http://llvm.org/docs/GoldPlugin.html))
  - [gcc LTO](https://gcc.gnu.org/onlinedocs/gccint/LTO-Overview.html)
  - Ahora mismo, 2016, clang y gcc soportan LTO simplemente añadiendo `-flto` en las opciones tanto de compilación como de enlazado.
  - `LTO` todavía necesita asentarse. A veces, si tu programa tiene código que no usas directamente pero alguna librería sí, LTO puede borrarlo, porque detecta que en tu código no se hace nunca una llamada a esa función.

Arquitectura

* `-march=native`
  - Le da al compilador permiso para usar todas las características de tu CPU
  - otra vez, compara el funcionamiento con los distintos tipos de optimización y que no tengan efectos secundarios.
* `msse2` y `-msse4.2` pueden ser útiles si necesitas características que no están disponibles en el sistema desde el que compilas.

## Escribiendo código

### Tipos

Si te encuentras escribiendo `char` o `int` o `short` o `long` o `unsigned`, lo estás haciendo mal.

Para los programas modernos deberías incluir `#include <stdint.h>` y usar los tipos _estándar_.

Los tipos estándar comunes son:

* `int8_t`, `int16_t`, `int32_t`, `int64_t` - enteros con signo
* `uint8_t`, `uint16_t`, `uint32_t`, `uint64_t` - enteros sin signo
* `float` - coma flotante de 32 bits
* `double` - coma flotante de 64 bits

Te darás cuenta que ya no tenemos `char`. `char` está malinterpretado en C.

Los desarrolladores han abusado de `char` para representar un byte incluso cuando hacen operaciones sin signo. Es mucho más limpio usar `uint8_t` para representar un único byte sin signo y `uint8_t *` para representar una secuencia de bytes sin signo.

#### Una excepción a nunca-`char`

El _único_ uso aceptable de `char` en 2016 es si una API ya existente necesita `char` (por ejemplo, `strncat`, `printf`,...) o si estás inicializando una cadena de texto de solo lectura (`const char *hello = "hello";`) porque el tipo de C para cadenas de texto sigue siendo `char *`

Además, en C11 tenemos soporte Unicode nativo y el tipo para cadenas UTF-8 sigue siendo `char *` incluso para secuencias multibyte como `const char *abcgrr = u8"abc😬";`.

#### El signo

A estas alturas de la película no deberías escribir `unsigned` nunca en tu código. Podemos escribir sin usar la fea convención de C para tipos multi-palabra que restan legibilidad. ¿Quién quiere escribir `unsigned long long int` cuando puede escribir `uint64_t`? Los tipos de `<stdint.h>` son más explícitos, más exactos en su significado y son más compactos en su escritura y su legibilidad.

Pero podrías decir, "¡Necesito hacer cast a punteros a `long` para realizar aritmética de punteros sucia!"

Podrías decirlo. Pero estás equivocado.

El tipo correcto para aritmética de punteros es `uintptr_t` definido en `<stddef.h>`.

En vez de:

{% highlight c %}

long diff = (long)ptrOld - (long)ptrNew;

{% endhighlight %}

Usa:

{% highlight c %}

ptrdiff_t diff = (uintptr_t)ptrOld - (uintptr_t)ptrNew;

{% endhighlight %}

Además:

{% highlight c %}

printf("%p is unaligned by %" PRIuPTR " bytes\",(void *)p, ((uintptr_t)somePtr & (sizeof(void *) - 1)));

{% endhighlight %}

#### Tipos dependientes del sistema

Sigues argumentando, "¡en una plataforma de 32 bits quiero longs de 32 bits y en una de 64 bits quiero longs de 64 bits!"

Si nos saltamos la idea de que estás introduciendo deliberadamente código que dificulta la comprensión del código al tener tamaños distintos dependiendo de la plataforma, aún no tendrías necesidad de usar `long`.

En estas situaciones debes usar `intptr_t` que se define según la plataforma en que te encuentres.

En plataformas de 32 bits, `intptr_t` es `int32_t`.

En plataformas de 64 bits, `intptr_t` es `int64_t`.

`intprt_t` también tiene una versión sin signo `uintptr_t`.

Para almacenar diferencias entre punteros, tenemos el `ptrdiff_t`.

#### Máxima capacidad

¿Quieres tener el entero con mayor capacidad de tu sistema?

La gente tiene a usar el más grande que conozca, en este caso `uint64_t` nos podrá almacenar el número más grande. Pero hay una manera más correcta de garantizar que podrá contener cualquier otro valor que se esté utilizando en el programa.

El contenedor más seguro para cualquier entero es `intmax_t` (también `uintmax_t`). Puedes asignar cualquier entero con signo a `intmax_t` sin pérdida de precisión. Puedes asignar cualquier entero sin signo a `uintmax_t` sin pérdida de precisión.

#### Ese otro tipo

Otro tipo que depende del sistema y es usado comúnmente es `size_t`.

`size_t` se define como "un entero capaz de contener el mayor tamaño de memoria disponible".

En el lado práctico, `size_t` es el tipo que devuelve el operador `sizeof`.

En cualquier caso, la definición de `size_t` es prácticamente la misma que la de `uintptr_t` en todas las plataformas modernas.

También existe `ssize_t` que es `size_t` con signo y que devuelve `-1` en caso de error. (Nota: `ssize_t` es POSIX así que no se aplica esto en Windows).

Así que, ¿debería usar `sisze_t` para aceptar tamaños dependientes del sistema en mis funciones? Sí, cualquier función que acepte un número de bytes puede usar `size_t`.

También lo puedes usar en malloc, y `ssize_t` es usado en `read()` y `write()` (solo en sistemas POSIX).

#### Mostrando tipos

Nunca debes hacer cast para mostrar el valor de los tipos. Usa siempre los especificadores adecuados.

Estos incluyen, pero no están limitados a:

* `size_t` - `%zu`
* `ssize_t` - `%zd`
* `ptrdiff_t` - `%td`
* valor del puntero - `%p` (muestra el valor en hexadecimanl, haz cast a `(void *)` primero)
* los tipos de 64 bits deben usar las macros `PRIu64` (sin signo) y `PRId64` (con signo)
 - es imposible especificar un valor correcto multiplataforma sin la ayuda de estas macros
* `intptr_t` - `"%" PRIdPTR`
* `uintptr_t` - `"%" PRIuPTR`
* `intmax_t` - `"%" PRIdMAX`
* `uintmax_t` - `"%" PRIuMAX`

Recordar que `PRI*` son macros, y las macros se tienen que expandir, no pueden estar dentro de una cadena de texto. No puedes hacer:

{% highlight c %}

printf("Local number: %PRIdPTR\n\n", someIntPtr);

{% endhighlight %}

deberías usar:

{% highlight c %}

printf("Local number: %" PRIdPTR "\n\n", someIntPtr);

{% endhighlight %}

Tienes que poner el símbolo '%' dentro de la cadena de texto, pero el especificador fuera.

### C99 permite declaraciones de variables en cualquier sitio

Así que no hagas esto:

{% highlight c %}
void test(uint8_t input) {
    uint32_t b;

    if (input > 3) {
        return;
    }

    b = input;
}
{% endhighlight %}

haz esto

{% highlight c %}
void test(uint8_t input) {
    if (input > 3) {
        return;
    }

    uint32_t b = input;
}
{% endhighlight %}

Aunque si tienes un bucle muy exigente (un _tight loop_) las declaraciones a mitad de camino pueden ralentizar el bucle.

### C99 permite a los bucles `for` declarar los contadores en la misma línea

Así que no hagas esto

{% highlight c %}
    uint32_t i;

    for (i = 0; i < 10; i++)
{% endhighlight %}

Haz esto:

{% highlight c %}

    for (uint32_t i = 0; i < 10; i++)

{% endhighlight %}

### La mayoría de compiladores soportan `#pragma once`

Así que no hagas esto:

{% highlight c %}

#ifndef PROJECT_HEADERNAME
#define PROJECT_HEADERNAME
.
.
.
#endif /* PROJECT_HEADERNAME */

{% endhighlight %}

haz esto:

{% highlight c %}

#pragma once

{% endhighlight %}

`#pragma once` le dice al compilador que solo incluya el archivo de cabecera una vez y no necesitas escribir esas tres líneas para evitarlo manualmente. Este pragma esta soportado por todos los compiladores modernos en todas las plataformas y está recomendado por encima de nombrar manualmente las cláusulas.

Para más detalles, observa la lista de compiladores que lo soportan en [pragma once](https://en.wikipedia.org/wiki/Pragma_once)

### C permite la inicialización estática de arrays ya asignados memoria

Así que no hagas:

{% highlight c %}

    uint32_t numbers[64];
    memset(numbers, 0, sizeof(numbers));

{% endhighlight %}

Haz esto:

{% highlight c %}

uint32_t numbers[64] = {0};

{% endhighlight %}

### C permite la inicialización estática de structs ya asignados en memoria

Así que no hagas esto:

{% highlight c %}

    struct thing {
        uint64_t index;
        uint32_t counter;
    };

    struct thing localThing;

    void initThing(void) {
        memset(&localThing, 0, sizeof(localThing));
    }

{% endhighlight %}

Haz esto:

{% highlight c %}

    struct thing {
        uint64_t index;
        uint32_t counter;
    };

    struct thing localThing = {0};

{% endhighlight %}

__NOTA IMPORTANTE:__ Si tu estructura tiene padding (relleno extra para coincidir con el alineamiento del procesador, todas por defecto en GCC, `__attribute__((__packed__))` para desactivar este comportamiento), el método de `{0}` no llenará de ceros los bits de padding. Si necesitases rellenar todo de ceros, incluido los bits de padding, deberás seguir usando `memset(&localThing, 0, sizeof(localThing))`.

Si necesitas reinicializar un struct puedes declarar un struct global a cero para asignar posteriormente.

{% highlight c %}
    struct thing {
        uint64_t index;
        uint32_t counter;
    };

    static const struct thing localThingNull = {0};
    .
    .
    .
    struct thing localThing = {.counter = 3};
    .
    .
    .
    localThing = localThingNull;
{% endhighlight %}

### C99 permite arrays de longitud variable (VLA)

Así que no hagas esto:

{% highlight c %}
    uintmax_t arrayLength = strtoumax(argv[1], NULL, 10);
    void *array[];

    array = malloc(sizeof(*array) * arrayLength);

    /* remember to free(array) when you're done using it */
{% endhighlight %}

Haz esto:

{% highlight c %}
    uintmax_t arrayLength = strtoumax(argv[1], NULL, 10);
    void *array[arrayLength];

    /* no need to free array */
{% endhighlight %}

__NOTA IMPORTANTE:__ Los VLA suelen situarse en el stack, junto a los arrays normales. Así que si no haces arrays de 3 millones de elementos normalmente, tampoco los hagas con esta sintaxis. Estos no son listas escalables tipo Python o Ruby. Si especificas una longitud muy grande en tiempo de ejecución tu programa podría empezar a hacer cosas raras. Los VLA están bien para situaciones pequeñas, de un solo uso y no se puede confiar en que escalen correctamente. 

Hay gente que considera la sintaxis de VLA un antipatrón puesto que puede cerrar tu programa fácilmente.

NOTA: Debes estar seguro que `arrayLength` tiene un tamaño adecuado (menos de un par de KB se te darán para VLA). No puede asignar arrays _enormes_ pero en casos concretos, es mucho más sencillo usar las capacidades de C99 VLA en vez de pringarse con malloc/free.

NOTA DOBLE: como puedes ver no hay ninguna verificación de entrada al usar VLA, así que cuida mucho el uso de las VLA.

### C99 permite indicar parámetros de punteros que no se solapan

Mira la palabra reservada [restrict](https://en.wikipedia.org/wiki/Restrict) (a veces, `__restrict`)

### Tipos de los parámetros

Si una función acepta arbitrariamente datos y longitud, no restrinjas el tipo del parámetro.

Así que no hagas:

{% highlight c %}
void processAddBytesOverflow(uint8_t *bytes, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        bytes[0] += bytes[i];
    }
}
{% endhighlight %}

Haz esto:

{% highlight c %}
void processAddBytesOverflow(void *input, uint32_t len) {
    uint8_t *bytes = input;

    for (uint32_t i = 0; i < len; i++) {
        bytes[0] += bytes[i];
    }
}
{% endhighlight %}

Los tipos de entrada definen la interfaz de tu código, no lo que tu código hace con esos parámetros. La interfaz del código dice "aceptar un array de bytes y una longitud", así que no quieres restringirles usar solo `uint8_t`. Quizá tus usuarios quieran pasar `char *` o algo más inesperado.

Al declarar el tipo de entrada como `void *` y haciendo cast dentro de tu función, los usuarios ya no tienen que pensar en abstracciones _dentro_ de tu librería.

Algunos lectores afirman que podría haber problemas de alineamiento con este ejemplo, pero como estamos accediendo a los bytes uno por uno no hay problema en realidad. Si por el contrario tuviéramos tipos más grandes tendríamos que vigilar posibles problemas de alineamiento, mirar [Unaligned Memory Access](https://www.kernel.org/doc/Documentation/unaligned-memory-access.txt)

### Parámetros de devolución

C99 nos da el poder de usar `<stdbool.h>` que define `true` como `1` y `false` como `0`.

Para valores de éxito/error, las funciones deben devolver `true` o `false`, nunca un entero especificando manualmente `1` y `0` (o peor, `1` y `-1` (¿o era `0` éxito y `1` error? ¿o era `0` éxito y `-1` error?))

Si una función modifica el valor de un parámetro de entrada, no lo devuelvas, usa dobles punteros.

Así que no hagas:

{% highlight c %}
void *growthOptional(void *grow, size_t currentLen, size_t newLen) {
    if (newLen > currentLen) {
        void *newGrow = realloc(grow, newLen);
        if (newGrow) {
            /* resize success */
            grow = newGrow;
        } else {
            /* resize failed, free existing and signal failure through NULL */
            free(grow);
            grow = NULL;
        }
    }

    return grow;
}
{% endhighlight %}

Haz esto:

{% highlight c %}
/* Return value:
 *  - 'true' if newLen > currentLen and attempted to grow
 *    - 'true' does not signify success here, the success is still in '*_grow'
 *  - 'false' if newLen <= currentLen */
bool growthOptional(void **_grow, size_t currentLen, size_t newLen) {
    void *grow = *_grow;
    if (newLen > currentLen) {
        void *newGrow = realloc(grow, newLen);
        if (newGrow) {
            /* resize success */
            *_grow = newGrow;
            return true;
        }

        /* resize failure */
        free(grow);
        *_grow = NULL;

        /* for this function,
         * 'true' doesn't mean success, it means 'attempted grow' */
        return true;
    }

    return false;
}
{% endhighlight %}

O incluso mejor:

{% highlight c %}
typedef enum growthResult {
    GROWTH_RESULT_SUCCESS = 1,
    GROWTH_RESULT_FAILURE_GROW_NOT_NECESSARY,
    GROWTH_RESULT_FAILURE_ALLOCATION_FAILED
} growthResult;

growthResult growthOptional(void **_grow, size_t currentLen, size_t newLen) {
    void *grow = *_grow;
    if (newLen > currentLen) {
        void *newGrow = realloc(grow, newLen);
        if (newGrow) {
            /* resize success */
            *_grow = newGrow;
            return GROWTH_RESULT_SUCCESS;
        }

        /* resize failure, don't remove data because we can signal error */
        return GROWTH_RESULT_FAILURE_ALLOCATION_FAILED;
    }

    return GROWTH_RESULT_FAILURE_GROW_NOT_NECESSARY;
}
{% endhighlight %}

### Formato

El estilo del código es muy importante.

Si tu proyecto tiene una guía de formato de 50 páginas, nadie te ayudará, pero si tu código tampoco se puede leer, nadie querrá ayudarte.

La solución es usar __siempre__ un programa para formatear el código.

El único formateador de código usable en el 2016 es [clang-format](http://clang.llvm.org/docs/ClangFormat.html). clang-format tiene los mejores ajustes por defecto y sigue en desarrollo activo.

Aquí está el script que uso para formatear mi código:

{% highlight bash %}
#!/usr/bin/env bash

clang-format -style="{BasedOnStyle: llvm, IndentWidth: 4, AllowShortFunctionsOnASingleLine: None, KeepEmptyLinesAtTheStartOfBlocks: false}" "$@"
{% endhighlight %}

Luego lo llamo
```
./script.sh -i *.{c,h,cc,cpp,hpp,cxx}
```

La opción `-i` indica que sobrescriba los archivos con los cambios que realice, en vez de generar nuevos archivos o crear copias.

Si tienes muchos archivos, puedes hacer la operación en paralelo

{% highlight bash %}
#!/usr/bin/env bash

# note: clang-tidy only accepts one file at a time, but we can run it
#       parallel against disjoint collections at once.
find . \( -name \*.c -or -name \*.cpp -or -name \*.cc \) |xargs -n1 -P4 cleanup-tidy

# clang-format accepts multiple files during one run, but let's limit it to 12
# here so we (hopefully) avoid excessive memory usage.
find . \( -name \*.c -or -name \*.cpp -or -name \*.cc -or -name \*.h \) |xargs -n12 -P4 cleanup-format -i
{% endhighlight %}

Y ahora el contenido del script cleanup-tidy aquí.

{% highlight bash %}
#!/usr/bin/env bash

clang-tidy \
    -fix \
    -fix-errors \
    -header-filter=.* \
    --checks=readability-braces-around-statements,misc-macro-parentheses \
    $1 \
    -- -I.
{% endhighlight %}

[clang-tidy](http://clang.llvm.org/extra/clang-tidy/) es una herramienta de refactorización basada en reglas. Las opciones de arriba activan dos arreglos:

* `readability-braces-around-statements` - fuerza a que todos los `if/while/for` tengan el cuerpo rodeado por llaves.
 - ha sido un error que C permitiese las llaves opcionales. Son causa de muchos errores, sobre todo al mantener el código con el tiempo, así que aunque el compilador te lo acepte, no dejes que ocurra.
* `misc-macro-parentheses` - añade automáticamente paréntesis alrededor de los parámetros usados en una macro.

`clang-tidy` es genial cuando funciona, pero para código complejo puede trabarse. Además, `clang-tidy` no formatea, así que necesitarás llamar a `clang-format` para formatear y alinear las nuevas llaves y demás cosas.

### Legibilidad

#### Comentarios

Comentarios con sentido, dentro del código, no muy extensos.

#### Estructura de archivos

Intenta no tener archivos de más de 1000 líneas (1500 como mucho)

### Otros detalles

#### Nunca uses `malloc`

Usa siempre `calloc`. No hay penalización de rendimiento por tener la memoria limpia, llena de ceros.

Los lectores han informado de un par de cosas:

* `calloc` sí tiene un impacto en el rendimiento en asignaciones __enormes__
* `calloc` sí tiene un impacto en el rendimiento en plataformas extrañas (sistemas empotrados, videoconsolas, hardware de 30 años de antigüedad, ...)
* una buena razón para no usar `malloc()` es que no puede comprobar si hay un desbordamiento y es un potencial fallo de seguridad

Todos son buenos puntos, razón por la que siempre debes probar el funcionamiento en todos los sistemas que puedas.

Una ventaja de usar `calloc()` directamente es que, al contrario que `malloc()`, `calloc()` puede comprobar un desbordamiento porque suma todo el tamaño necesario antes de que lo pida.

Algunas referencias al uso de `calloc()` se pueden encontrar aquí:

* [Benchmarking fun with calloc() and zero pages (2007)](https://blogs.fau.de/hager/archives/825)
* [Copy-on-write in virtual memory management](https://en.wikipedia.org/wiki/Copy-on-write#Copy-on-write_in_virtual_memory_management)

Sigo recomendando usar siempre `calloc()` para la mayoría de escenarios en 2016.

#### Nunca uses memset (si puedes evitarlo)

Nunca hagas `memset(ptr, 0, len)` cuando puedes inicializar una estructura (o un array) con `{0}`.

## Generics en C11

C11 ha añadido los __Generics__. Funcionan como un switch, que distingue entre los tipos y dependiendo del valor que se le de devuelve una u otra cosa. Por ejemplo:

{% highlight c %}
#define probarGenerics(X) _Generic((X), char: 1, int32_t: 2, float: 3, default: 0)

probarGenerics('a') // devolverá 1
probarGenerics(2) // devolverá 2
{% endhighlight %}