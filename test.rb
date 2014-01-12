#!/usr/bin/env ruby

### CONSTANTES ###
# Cantidad de columnas para estructurar la salida
COLUMN_NUM  = 4
# Tamaño de cada columna
COLUMN_SIZE = 15

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
# 3. Si el comando falla, muestra "failed" y termina la ejecución.
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
class Array
  def sum
    inject(0){|sum, x| sum + x}
  end
end

class Float
  def to_s
    "%.3f" % self
  end
end

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
    row(@i, @estimation, @error, @time)
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
    @name = File.basename(@dataset, '.dat')
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
      result = `./words -M #{@memory} -S #{seed} #{@dataset}`
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
    # Ruta dataset
    dataset_path = "#{dir}/#{@name}/%s_#{@memory}"

    # Rutas de archivos para el dataset
    sample_file  = dataset_path % 'sample'
    summary_file = dataset_path % 'summary'
    count_file   = dataset_path % 'count'

    # Se prepara el directorio que contendrá los resultados, a no ser que exista
    unless File.exists?("")
      status "Creating directory #{dir}/#{@name}", "mkdir -p #{dir}/#{@name}"
    end

    save_sample sample_file 
    save_summary summary_file
    save_count count_file
  end

  def save_sample(sample_file)
    # Crear el fichero con la muestra
    File.open("#{sample_file}.txt", 'w') do |file|
      file.puts Case.header
      file.puts *@cases
    end

    say_status "Writing file #{sample_file}.txt", :done
  end

  def save_summary(summary_file)
    # Crear el fichero con información general
    header = [ 'real', 'total', 'avgEstimation', 'stdError', 'avgTimeMs', 'timePerWordUs' ]
    body   = [ @real, @total, average(:estimation), standard_error, average(:time), time_per_word ]

    File.open("#{summary_file}.txt", 'w') do |file|
      file.puts row(*header), row(*body)
    end

    say_status "Writing file #{summary_file}.txt", :done

    File.open("#{summary_file}.tex", 'w') do |file|
      file.print body.join(' & ')
      file.puts '\\\ \hline'
    end

    say_status "Writing file #{summary_file}.tex", :done
  end

  def save_count(count_file)
    header = ['0to1', '1to5']
    body = [ count_error_between(0, 0.01), count_error_between(0.01, 0.05) ]

    3.times do |i|
      start = (i+1)*5
      fin   = start+5

      header << "#{start}to#{fin}"
      body   << count_error_between(start/100.0, fin/100.0)
    end

    header << '20to100'
    body   << count_error_between(0.2, 1.0)

    header << 'total'
    body   << body.sum

    # Crear el fichero con recuento
    File.open("#{count_file}.txt", 'w') do |file|
      file.puts row(*header)
      file.puts row(*body)
    end

    say_status "Writing file #{count_file}.txt", :done

    File.open("#{count_file}.tex", 'w') do |file|
      file.print body.first(body.size-1).join(' & ')
      file.puts '\\\ \hline'
    end

    say_status "Writing file #{count_file}.tex", :done
  end

  def average(attribute)
    @cases.map{ |sample_case| sample_case.send(attribute) }.sum / @cases.size
  end

  def time_per_word
    (average(:time) / @total) * 1000
  end

  def standard_error
    est = @cases.map{ |sample_case| sample_case.estimation**2 }.sum / @cases.size
    Math.sqrt(est - average(:estimation)**2) / @real
  end

  def count_error_between(a, b)
    @cases.select{ |sample_case| a <= sample_case.error and sample_case.error < b }.size
  end
end

### PROGRAMA PRINCIPAL ###
# Obtener los argumentos
datasets, memorys, num_cases, dir = ARGV

# Valores por defecto
datasets     = "*" if datasets.nil? or datasets == "all"
memorys    ||= "1024"
num_cases  ||= "200"
dir        ||= "data"

# Pedir confirmación si el directorio de muestras ya existe
if File.exists?(dir)
  puts "This may overwrite files found in #{dir}..."
  print "Are you sure? [y/n] "
  exit(1) unless $stdin.gets.chomp == "y"
end

# Generar el ejecutable a través del Makefile
status "Making executable", "make"

memorys = memorys.split(',')

# Dir[ruta] devuelve un Array de strings con los archivos desde el directorio de
# trabajo que coinciden con la ruta. Por defecto la ruta es: "dataset/*.dat",
# por lo que se obtienen muestras de todos los datasets.
# Por cada dataset que coincida con la ruta, de manera ordenada:
Dir["dataset/#{datasets}.dat"].sort!.each do |dataset|
  memorys.each do |memory|
    puts "#{dataset} with #{memory} bytes".center(COLUMN_NUM * COLUMN_SIZE, '=')

    sample = Sample.new(dataset, memory.to_i)
    sample.obtain_cases!(num_cases.to_i)
    sample.save(dir)
  end

  puts separator
end
