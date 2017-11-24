require_relative "stats"
require_relative "histogram"

def main(title, avg_times)
  puts "Average value is #{avg_times.mean}"
  puts "Median value is #{avg_times.median}"

  average = 0.0
  trials = 100000
  histogram = Histogram.new
  trials.times do
    sample = avg_times[rand(avg_times.size)]
    average += sample
    histogram.add(sample)
  end
  puts "Average value computed is #{average/trials}"
  top_value, ntimes  = histogram.max_freq
  puts "Found #{top_value} value #{ntimes} times"

  histogram.dump(title + ".dat")
end

puts
puts "Traffic time in NC"
main("TrafficNC", [10, 30, 5, 25, 40, 20, 10, 15, 30, 20, 
      15, 20, 85, 15, 65, 15, 60, 60, 40, 45].sort)

puts
puts "Traffic time in NY city"
main("TrafficNY", [5,10,10,15,15,15,15,20,20,20,25,30,30,40,40,45,60,60,65,85])
