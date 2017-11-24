# Tiger distance by his driver a distance that is normal with (304, 8)ft
# What percentage of his shot is at least 290 yards.

require_relative "random_gaussian"

dist = RandomGaussian.new(304, 8)
num_trials = 1000000
hits = 0
num_trials.times do 
  distance = dist.rand
  hits += 1 if distance > 290
end
puts "Percentage of shots at least 290 yards=#{hits.to_f/num_trials * 100.0}"


