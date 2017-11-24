require_relative "stats"
require_relative "histogram"

arr = [10, 30, 5, 25, 40, 20, 10, 15, 30, 20, 
      15, 20, 85, 15, 65, 15, 60, 60, 40, 45]

puts "mean is #{arr.mean}"
puts "std dev is #{arr.std_dev}"
orig_histogram = Histogram.new
orig_histogram.add(arr)
orig_histogram.dump("orig_histogram.dat")

incr_arr = arr.map {|x| x * 3.0 }
incr_histogram = Histogram.new
incr_histogram.add(incr_arr)
incr_histogram.dump("mult_histogram.dat")

puts "Mean of multiple by 3 is #{incr_arr.mean}"
puts "Std dev of multiply by 3 is #{incr_arr.std_dev}"

decr_arr = arr.map {|x| x / 3.0 }

puts "Mean of divide by 3 is #{decr_arr.mean}"
puts "Std dev of divide by 3 is #{decr_arr.std_dev}"
decr_histogram = Histogram.new
decr_histogram.add(decr_arr)
decr_histogram.dump("div_histogram.dat")
