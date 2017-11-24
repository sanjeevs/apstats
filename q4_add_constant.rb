require_relative "stats"
require_relative "histogram"

arr = [10, 30, 5, 25, 40, 20, 10, 15, 30, 20, 
      15, 20, 85, 15, 65, 15, 60, 60, 40, 45]

puts "mean is #{arr.mean}"
puts "std dev is #{arr.std_dev}"
orig_histogram = Histogram.new
orig_histogram.add(arr)
orig_histogram.dump("orig_histogram.dat")

incr_arr = arr.map {|x| x + 10 }
incr_histogram = Histogram.new
incr_histogram.add(incr_arr)
incr_histogram.dump("incr_histogram.dat")

puts "Mean of increment by 10 is #{incr_arr.mean}"
puts "Std dev of increment by 10 is #{incr_arr.std_dev}"

decr_arr = arr.map {|x| x - 10 }

puts "Mean of decrement by 10 is #{decr_arr.mean}"
puts "Std dev of decrement by 10 is #{decr_arr.std_dev}"
