#!/usr/bin/env ruby

### CONSTANTES ###
# Cantidad de columnas para estructurar la salida
COLUMN_NUM  = 4
# Tamaño de cada columna
COLUMN_SIZE = 12

### FUNCIONES ###
# Devuelve diferentes datos en columnas.
# Por ejemplo:
#   row(1, 2, 3, 4)
#    => "1           2           3           4           "
def row(*cols)
  row = ""
  cols.each { |col| row += col.to_s.ljust(COLUMN_SIZE) }
  return row
end

# Devuelve una cadena de '-'.
def separator
  "-" * (COLUMN_NUM * COLUMN_SIZE)
end

# Imprime message alineado a la izquierda y status a la derecha:
# message                                          status
def say_status(message, status)
  message += '...'
  puts message + status.to_s.rjust((COLUMN_SIZE * COLUMN_NUM) - message.size)
end

# Recibe un mensaje y un comando a ejecutar en la shell.
# 1. Imprime y muestra el mensaje alineado a la izquierda.
# 2. Ejecuta el comando
# 3. Si el comando falla, muestra "failed" i termina la ejecución.
#    Si el comando se ejecuta correctamente, muestra "done" y devuelve una string con el output
#    producido por la ejecución del comando.
def status(message, cmd)
  print message + '...'
  $stdout.flush

  # Ejecuta el comando y guarda su salida en result
  result = `#{cmd}`

  # $?.exitstatus tiene el valor de salida del último comando ejecutado
  print "\r"
  say_status message, ($?.exitstatus == 0 ? :done : :failed)

  exit(1) unless $?.exitstatus == 0
  return result
end

### CLASES ###
# Representa un caso de una muestra
class Case
  # Esta línea autogenera métodos para leer atributos
  attr_reader :i, :estimation, :error, :time

  # Constructora
  def initialize(i, estimation, error, time)
    @i = i
    @estimation = estimation
    @error = error
    @time = time
  end

  # La representación de un caso en String es la fila de una tabla
  def to_s
    row(@i, @estimation, "%.3f" % @error, "%.3f" % @time)
  end

  # Devuelve la cabecera de la tabla para cualquier caso
  def self.header
    row("i", "est", "relError", "timeMs")
  end
end

# Representa una muestra
class Sample
  def initialize(dataset, memory)
    @dataset = dataset
    @memory = memory
    @cases = []

    # Obtener el número total de palabras y el número de palabras únicas:
    # wc devuelve valores separados por espacios. Interesa el segundo (número de palabras).
    @total = status('Calculating total number of words', "wc #{@dataset}").split[1].to_i
    @real = status('Calculating number of unique words', "sort -u #{@dataset} | wc").split[1].to_i
  end

  # Obtiene num_cases nuevos casos y los añade a la muestra
  def obtain_cases!(num_cases)
    # Mostramos la cabacera de la tabla, a modo informativo
    puts Case.header

    # Repetir num_cases veces
    num_cases.times do |i|
      # Obtenemos una semilla representable en 32 bits
      seed = Random.new_seed % 2147483647 # Primo de Mersenne (2^31 - 1)

      # Ejecutar el programa y obtener datos
      start = Time.now
      result = `./words -M #{@memory} -S #{seed} < #{@dataset}`
      finish = Time.now

      # La estimación es el primer entero devuelto
      estimation = result.split.first.to_i

      # Computar el error relativo
      error = (@real - estimation.to_f).abs / @real

      # Calcular el tiempo de ejecución en milisegundos
      time = (finish - start) * 1000

      # Añadir el nuevo caso
      @cases << Case.new(@cases.size + 1, estimation, error, time)

      # Mostrar el caso añadido
      puts @cases.last
    end
  end

  # Guarda la muestra en el directorio dado
  def save(dir)
    # Nombre del dataset
    dataset_name = File.basename(@dataset, '.dat')
    # Ruta del archivo que contendrá información general de la muestra
    summary_file = "#{dir}/#{dataset_name}/summary_#{@memory}.txt"
    # Ruta del archivo que contendrá la muestra
    sample_file  = "#{dir}/#{dataset_name}/sample_#{@memory}.txt"

    # Se prepara el directorio que contendrá los resultados, a no ser que exista
    unless File.exists?("#{dir}/#{dataset_name}")
      status "Creating directory #{dir}/#{dataset_name}", "mkdir -p #{dir}/#{dataset_name}"
    end

    # Crear el fichero con la muestra
    File.open(sample_file, 'w') do |file|
      file.puts Case.header
      @cases.each { |current_case| file.puts current_case }
    end

    say_status "Writing file #{sample_file}", :done

    # Crear el fichero con información general
    File.open(summary_file, 'w') do |file|
      file.puts row('real', 'total')
      file.puts row(@real, @total)
    end

    say_status "Writing file #{summary_file}", :done
  end
end

### PROGRAMA PRINCIPAL ###
# Obtener los argumentos
num_cases, memory, dataset, dir = ARGV

# Valores por defecto
num_cases    = num_cases.to_i || 50
memory       = memory.to_i    || 1024
dataset      = "*" if dataset.nil? or dataset == "all"
dir        ||= "data"

# Pedir confirmación si el directorio de muestras ya existe
if File.exists?(dir)
  puts "This may overwrite files found in #{dir}..."
  print "Are you sure? [y/n] "
  exit(1) unless $stdin.gets.chomp == "y"
end

# Generar el ejecutable a través del Makefile
status "Making executable", "make"

# Dir[ruta] devuelve un Array de strings con los archivos desde el directorio de
# trabajo que coinciden con la ruta. Por defecto la ruta es: "dataset/*.dat",
# por lo que se obtienen muestras de todos los datasets.
# Por cada dataset que coincida con la ruta, de manera ordenada:
Dir["dataset/#{dataset}.dat"].sort!.each do |dataset|
  # Imprimir la ruta del dataset como título
  puts dataset.center(COLUMN_NUM * COLUMN_SIZE, '=')

  sample = Sample.new(dataset, memory)
  sample.obtain_cases!(num_cases)
  sample.save(dir)

  puts separator
end
