Contenido realizado en la entrega:
===================================

Directorio ./:
-----------------------------------
Archivos que incluye:
  report.pdf:
    Informe de la investigación realizada sobre la estimación de la cardinalidad.

  test.rb:
    Script que realiza la obtención de muestras. Para que encuentre los datasets,
    éstos deben estar ubicados en el directorio './dataset/'.

    Recibe 4 parámetros:
      1. Datasets de los que recoger muestras.  Por defecto: todos
      2. Memorias de las que recoger muestras.  Por defecto: 1024
      3. Cantidad de casos por muestra.         Por defecto: 200
      4. Directorio donde guardar las muestras. Por defecto: data

    Ejemplos de uso:
      Con los parámetros por defecto:
        $ ruby test.rb

      Para la muestra D1, memorias de 32, 64 y 128, 100 casos por muestra
      y guardando las muestras en el directorio: ejemplo
        $ ruby test.rb D1 "32 64 128" 100 ejemplo

      Para las muestras D1 y D2, todo lo demás por defecto:
        $ ruby test.rb "D1 D2"

  plots.r:
    Script que genera las gráficas en './plots/' a partir de los datos en data.
    Puede dar error si no tiene todos los datos necesarios.
    Normalmente es ejecutado por el script anterior al hacer una obtención
    de muestras por defecto.

    Uso:
      $ Rscript plots.r RUTA_DIRECTORIO_ACTUAL

  Makefile:
    Compila el estimador de cardinalidad en C++ y genera un ejecutable
    llamado: words

    Uso:
      $ make

  words:
    Programa que implementa el algoritmo HyperLogLog que realiza estimación
    de la cardinalidad. Se obtiene el compilar a través del Makefile.

    Uso:
      $ words [-S semilla] [-M memoria] RUTA_ARCHIVO

      -S especifica la semilla aleatoria.          Por defecto: tiempo actual
      -M especifica el límite de memoria en bytes. Por defecto: 1024

      Ejemplos:
        $ ./words dataset/D8.dat
        $ ./words -M 8192 dataset/D8.dat
        $ ./words -S 1234 -M 256 dataset/D1.dat
        $ ./words -S 4321 dataset/D2.dat

Directorio ./src/:
-----------------------------------
Contiene el código fuente del programa que realiza la estimación.

Archivos que incluye:
  main.cpp:
    Programa principal.

  estimators/CardinalityEstimator.hpp:
    Clase abstracta que define la API para todo estimador.

  estimators/HyperLogLog.{hpp, cpp}:
    Clase que implementa el algoritmo HyperLogLog.

  hashing/Dbj2Hash.{hpp, cpp}:
    Clase que implementa la función de hash djb2.

Directorio ./data/:
-----------------------------------
Contiene los datos de las muestras utilizadas para el análisis estadístico.

Directorio ./plots/:
-----------------------------------
Contiene las gráficas obtenidas de las muestras anteriormente mencionadas.
