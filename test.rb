#!/usr/bin/env ruby

COLUMNS = ["#", "estimation", "rel. error", "time (ms)"]
COLUMN_SIZE = 12

def title(title)
  puts title.center(COLUMNS.size * COLUMN_SIZE, "=")
end

def row(*cols)
  cols.each { |col| print col.to_s.ljust COLUMN_SIZE }
  puts ""
end

def separator
  puts "-" * (COLUMNS.size * COLUMN_SIZE)
end

print "Making executable... "
`make`
puts "Done"

test_num, memory = ARGV

test_num ||= 10
memory   ||= 1024

puts "Performing #{test_num} tests using #{memory} bytes of memory..."

Dir["test/*.dat"].sort!.each do |test|
  real = `sort -u #{test} | wc`.split[0].to_i
  
  title test + " - " + real.to_s

  row *COLUMNS

  test_num.to_i.times do |i|
    seed = Random.new_seed % 2147483647

    start = Time.now
    result = `./words -M #{memory} -S #{seed} < #{test}`
    finish = Time.now

    estimation, total = result.split

    row i+1, estimation, ((real - estimation.to_f) / real).abs.round(5), ((finish - start) * 1000).round(5)
  end

  separator
end

puts "Memory used: #{memory} bytes"
