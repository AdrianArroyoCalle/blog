---
title: Post Mortem: Torre Utopía
description: Análisis de Torre Utopía, lo que fue bien y lo que fue mal

---

Torre Utopía fue un juego diseñado con el objetivo de ser creado en menos de un mes usando solo mis ratos libres. Para facilitar el trabajo había diseñado un conjunto de librerías y scripts en lo que denomino _esqueleto_. Este esqueleto es open-source y lo podeis encontrar en [GitHub](http://github.com/AdrianArroyoCalle/skeleton-npm-game).

# Desarrollo

Torre Utopía esta fuertemente inspirado en Elevator Action. Inicialmente iba a ser un clon del juego pero según avanzó el desarrollo del juego vi partes que no eran fáciles de implementar y que requerirían un rediseño. Estoy hablando sobre todo del scrolling. Torre Utopía inicialmente fue pensado para ser programado en TypeScript que es como el esqueleto lo admite por defecto. Sin embargo terminé usando muy poco las características de TypeScript. Creo que porque no tengo soltura suficiente todavía en TypeScript como para usarlo correctamente. Aun así la inclusión fue positiva en cierto punto porque el compilador era capaz de avisarme de variables no definidas, un error que en JavaScript corriente es tedioso de solucionar pues debes mirar la consola del navegador.

Un acierto, creo yo, fue usar gráficos pre-generados para ir probando las mecánicas. Esto facilita mucho desde el principio saber como va a quedar cada cosa. Sin embargo, este arte pregenerado no fue sustituido al final enteramente dando una mala imagen al espectador. Realmente se cambiarón muchos gráficos pero la falta de tiempo hizo que tuviesen poco nivel de detalle. Una cosa que no me gustó fue que el personaje se moviera mirándote a ti. Y me cabrea más cuando pienso que hacerlo bien es muy sencillo de implementar.

# Final

# Distribución

# Recepción


# Conclusión
