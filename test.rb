#!/usr/bin/env ruby

COLUMN_NUM  = 4
COLUMN_SIZE = 12

class File
  def puts(*args)
    super(*args)
    $stdout.puts(*args)
  end
end

def title(title)
  title.center(COLUMN_NUM * COLUMN_SIZE, "=")
end

def row(*cols)
  row = ""
  cols.each { |col| row += col.to_s.ljust COLUMN_SIZE }
  row
end

def separator
  "-" * (COLUMN_NUM * COLUMN_SIZE)
end

def status(message, cmd)
  message += '... '

  print message
  $stdout.flush
  result = `#{cmd}`
  
  status = ($?.exitstatus == 0 ? "done" : "failed")

  puts status.rjust (COLUMN_SIZE * COLUMN_NUM) - message.size
  result
end


test_num, memory, test, dir = ARGV

test_num ||= 10
memory   ||= 1024
test     = "*" if test.nil? or test == "all"
dir      ||= "data"

if File.exists?(dir)
  print "This may overwrite files found in #{dir}. Are you sure? [y/n] "
  exit(1) unless $stdin.gets.chomp == "y"
end

status "Making executable", 'make'
puts "Performing #{test_num} tests using #{memory} bytes of memory..."

Dir["test/#{test}.dat"].sort!.each do |test|
  test_name = File.basename(test, '.dat')
  sample_file = "#{dir}/#{test_name}/sample_#{memory}.txt"
  summary_file = "#{dir}/#{test_name}/summary_#{memory}.txt"
  
  puts title test
  status "Creating directory #{dir}/#{test_name}", "mkdir -p #{dir}/#{test_name}"
  total = status('Calculating total number of words', "wc #{test}").split[0].to_i
  real = status('Calculating real number of unique words', "sort -u #{test} | wc").split[0].to_i
  
  puts "Writing file #{summary_file}..."

  File.open(summary_file, 'w') do |file|
    file.puts row('real', 'total')
    file.puts row(real, total)
  end

  puts "Writing file #{sample_file}..."

  File.open(sample_file, 'w') do |file|
    file.puts row("i", "est", "relError", "timeMs")

    test_num.to_i.times do |i|
      seed = Random.new_seed % 2147483647
      result = `bash -c "TIMEFORMAT='%3R'; time ./words -M #{memory} -S #{seed} < #{test}" 2>&1`

      estimation = result.lines.first.split[0].to_i
      time = (result.lines.last.to_f * 1000).to_i
      error = "%.3f" % ((real - estimation.to_f) / real).abs

      file.puts row(i+1, estimation, error, time)
    end
  end

  puts separator
end
