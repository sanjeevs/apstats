require 'pp'
require 'optparse'
require 'ostruct'
require_relative 'stats'
require_relative 'sample_distrib'
require_relative 'random_gaussian'

Banner = <<EOF
A distribtution of protozoan is normal with a mean of 46.7 days and std dev of 3.2 days.
a) Find the prob that a protozoan selected at random will live for at least 52 days.
b) Find the prob that a SRS of 25 protozoan will have a mean expectancy of at least 53 days.
Usage: q2_protozoan.rb [options]
EOF

def main(options)
  population = RandomGaussian.new(options[:mean], options[:std_dev]).population(options[:population_size])

  sample_stats = run_sample_trials(population, options) do |lifetime|
    (lifetime <= options[:mean]) ? 1 : 0
  end
  puts %Q[Chk)Probability that sample of #{options[:sample_size]} will be true for lifetime <= #{options[:mean]}\
        days is  #{sample_stats.mean}"]

  options[:lifetime] = 52
  options[:result_file] = "q2_a.txt"
  sample_stats = run_sample_trials(population, options) do |lifetime|
    (lifetime >= options[:lifetime]) ? 1 : 0
  end

  puts %Q[a)Probability that sample of #{options[:sample_size]} will be true for lifetime >= #{options[:lifetime]}\
        days is  #{sample_stats.mean}"]

  
  options[:lifetime] = 53
  options[:result_file] = "q2_b.txt"
  options[:num_samples] = 25
  options[:num_trials] = 1
  result = []
  sample_stats = run_sample_trials(population, options) do |lifetime|
    result << lifetime
    (lifetime >= options[:lifetime]) ? 1 : 0
  end
  puts result
  puts "Mean number in sample is #{result.mean}"
  puts "Std dev of number in sample is #{result.std_dev}"
end

# Run trials to compute the sample values
def run_sample_trials(population, options)
  result = []
  freq_successes = Hash.new(0)

  options[:num_trials].times do |i|
    num_successes = run_trial(options[:num_samples], population) do |lifetime|
      yield(lifetime)
    end
    freq_successes[num_successes] += 1 
    result << num_successes
    (options[:num_samples]-1).times { result << 0 }
  end

  if(options[:result_file])
    File.open(options[:result_file], "w") do |fh|
      fh.puts "#NumSuccess NumTimes"
      freq_successes.sort_by {|key, value| key}.each do |v|
        fh.puts "#{v[0]}\t\t#{v[1]}"
      end
    end
  end

  stats = OpenStruct.new
  stats.mean = result.mean
  stats.std_dev = result.std_dev
  return stats
end

# Actual sampling experiment.
def run_trial(num_samples, population)
  num_successes = 0
  num_samples.times do 
    idx = rand(population.size).to_i
    num_successes += yield(population[idx])
  end
  num_successes
end

def create_options
  options = {num_samples: 1, num_trials: 1000000, result_file: nil, lifetime: 52,
             population_size: 1000000, mean: 46.7, std_dev: 3.2}
  
  parser = OptionParser.new do |opts|
    opts.banner = Banner
    opts.on('-n NumSamples', '--num_samples n') do |num_samples|
      options[:num_samples] = num_samples.to_i
    end
    opts.on('-t Trails', '--num_trials n') do |num_trials|
      options[:num_trials] = num_trials.to_i
    end
    opts.on('-o file', '--output filename') do |result_file|
      options[:result_file] = result_file 
    end
    opts.on('-l Lifetime', '--lifetime N') do |lifetime|
      options[:lifetime] = lifetime.to_f
    end
    opts.on('-p PopulationSize', '--population_size N') do |population_size|
      options[:population_size] = population_size.to_i
    end
    opts.on('-m Mean', '--mean N') do |mean|
      options[:mean] = mean.to_f
    end
    opts.on('-s StdDev', '--std_dev F') do |std_dev|
      options[:std_dev] = std_dev.to_f
    end
  end.parse!

  return options
end

main(create_options)
