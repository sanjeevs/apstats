# Assume a normal distribution of (50,10). If we halve all the values 
# then what is the shape of the new population.

require_relative 'random_gaussian'
require_relative 'histogram'

r = RandomGaussian.new(50,10)
orig_population = r.population(1000)

div2_population = orig_population.map {|e| e/2.0 }

h = Histogram.new do |key|
  key.to_i
end

h.add(orig_population)
h.dump("orig_population.dat")

h.clear
h.add(div2_population)
h.dump("div2_population.dat")

h.clear
h.add(orig_population.map { |e| e*2.0})
h.dump("mul2_population.dat")


