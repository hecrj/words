#!/usr/bin/env ruby

##############
# CONSTANTES #
##############
# Cantidad de columnas para estructurar la salida
COLUMN_NUM  = 4
# Tamaño de cada columna
COLUMN_SIZE = 12

##############
### CLASES ###
##############
# En Ruby puedes abrir cualquier clase en cualquier momento y
# redeclarar/añadir métodos. Incluso en las clases nativas.
# En este caso se redeclara el método puts de File para que sus
# parámetros, además de ser escritos en el archivo, sean
# imprimidos por la salida estándar.
class File
  def puts(*args)
    super(*args)
    $stdout.puts(*args)
  end
end

#################
### FUNCIONES ###
#################
# Se utiliza para centrar una string rodeándola de '='.
# Por ejemplo:
#   title("test/D1.dat")
#   => "==================test/D1.dat==================="
def title(title)
  title.center(COLUMN_NUM * COLUMN_SIZE, "=")
end

# Se utiliza para colocar diferentes datos en columnas en una fila.
# Por ejemplo:
#   row(1, 2, 3, 4)
#   => "1           2           3           4           "
def row(*cols)
  row = ""
  cols.each { |col| row += col.to_s.ljust COLUMN_SIZE }
  return row
end

# Devuelve una cadena de '-'.
def separator
  "-" * (COLUMN_NUM * COLUMN_SIZE)
end


# Recibe un mensaje y un comando a ejecutar en la shell.
# 1. Imprime y muestra el mensaje alineado a la izquierda.
# 2. Ejecuta el comando
# 3. Si el comando falla, muestra "failed" i termina la ejecución.
#    Si el comando se ejecuta correctamente, muestra "done"
#    y devuelve una string con el output producido por la ejecución
#    del comando.
def status(message, cmd)
  message += '... '

  print message
  $stdout.flush

  # Ejecuta el comando y guarda su salida en result
  result = `#{cmd}`
  # $?.exitstatus tiene el valor de salida del último comando ejecutado
  status = ($?.exitstatus == 0 ? "done" : "failed")
  puts status.rjust((COLUMN_SIZE * COLUMN_NUM) - message.size)

  exit(1) unless $?.exitstatus == 0
  return result
end

######################
# PROGRAMA PRINCIPAL #
######################
# Obtener los argumentos
sample_num, memory, dataset, dir = ARGV

# Valores por defecto
sample_num ||= 50
memory     ||= 1024
dataset      = "*" if dataset.nil? or dataset == "all"
dir        ||= "data"

# Pedir confirmación si el directorio de muestras ya existe
if File.exists?(dir)
  puts "This may overwrite files found in #{dir}..."
  print "Are you sure? [y/n] "
  exit(1) unless $stdin.gets.chomp == "y"
end

# Generar el ejecutable a través del Makefile
status "Making executable", 'make'
puts "Obtaining #{sample_num} samples using #{memory} bytes of memory..."

# Dir[ruta] devuelve un Array de strings con los archivos desde el directorio de
# trabajo que coinciden con la ruta. Por defecto la ruta es: "dataset/*.dat",
# por lo que se obtienen muestras de todos los datasets.
# Por cada dataset que coincida con la ruta, de manera ordenada:
Dir["dataset/#{dataset}.dat"].sort!.each do |dataset|
  # Nombre del dataset
  dataset_name = File.basename(dataset, '.dat')
  # Ruta del archivo que contendrá información general de la muestra
  summary_file = "#{dir}/#{dataset_name}/summary_#{memory}.txt"
  # Ruta del archivo que contendrá la muestra
  sample_file  = "#{dir}/#{dataset_name}/sample_#{memory}.txt"
  
  puts title(dataset)

  # Se prepara el directorio que contendrá los resultados, a no ser que exista
  unless File.exists?("#{dir}/#{dataset_name}")
    status "Creating directory #{dir}/#{dataset_name}", "mkdir -p #{dir}/#{dataset_name}"
  end

  # wc devuelve valores separados por espacios. Interesa el segundo (número de palabras).
  total = status('Calculating total number of words', "wc #{dataset}").split[1].to_i
  real = status('Calculating real number of unique words', "sort -u #{dataset} | wc").split[1].to_i
  
  puts "Writing file #{summary_file}..."

  # Crear el fichero con información general
  File.open(summary_file, 'w') do |file|
    file.puts row('real', 'total')
    file.puts row(real, total)
  end

  puts "Writing file #{sample_file}..."

  # Crear el fichero con la muestra
  File.open(sample_file, 'w') do |file|
    file.puts row("i", "est", "relError", "timeMs")

    # Repetir sample_num veces
    sample_num.to_i.times do |i|
      # Obtenemos una semilla representable en 32 bits
      seed = Random.new_seed % 2147483647 # Primo de Mersenne (2^31 - 1)

      # Obtener un caso de la muestra
      start = Time.now
      result = `./words -M #{memory} -S #{seed} < #{dataset}`
      finish = Time.now

      # La estimación es el primer entero devuelto
      estimation = result.split.first.to_i
      # Computar el error relativo
      error = (real - estimation.to_f).abs / real
      # Calcular el tiempo de ejecución en milisegundos
      time = (finish - start) * 1000

      # Añadir el caso al fichero con 3 decimales de precisión
      file.puts row(i+1, estimation, "%.3f" % error, "%.3f" % time)
    end
  end

  puts separator
end
