require 'pp'
require 'optparse'
require 'ostruct'
require_relative 'stats'
require_relative 'sample_distrib'
require_relative 'random_gaussian'

def main(options)
  population = RandomGaussian.new(options[:mean], options[:std_dev]).population(options[:population_size])

  sample_stats = run_sample_trials(population, options)

end

# Run trials to compute the sample values
def run_sample_trials(population, options)
  result = []
  freq_successes = Hash.new(0)

  options[:num_trials].times do |i|
    num_successes = run_trial(options[:num_samples], population) do |lifetime|
      lifetime >= options[:lifetime] ? 1 : 0
    end
    freq_successes[num_successes] += 1 
    result << num_successes 
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
  options = {num_samples: 5, num_trials: 1000000, result_file: nil, lifetime: 52,
             population_size: 1000000, mean: 46.7, std_dev: 3.2}
  
  parser = OptionParser.new do |opts|
    opts.banner = <<EOF
A distribtution of protozoan is normal with a mean of 46.7 days and std dev of 3.2 days.
Find the prob that a protozoan selected at random will live for at least 52 days.
Usage: q2_protozoan.rb [options]
EOF
    opts.on('-n', '--num_samples') do |num_samples|
      options[:num_samples] = num_samples
    end
    opts.on('-t', '--num_trials') do |num_trials|
      options[:num_trials] = num_trials.to_i
    end
    opts.on('-o', '--output') do |reuslt_file|
      options[:result_file] = result_file 
    end
    opts.on('-l', '--lifetime') do |lifetime|
      options[:lifetime] = lifetime.to_f
    end
    opts.on('-p', '--population_size') do |population_size|
      options[:lifetime] = population_size.to_i
    end
    opts.on('-m', '--mean') do |mean|
      options[:mean] = mean.to_f
    end
    opts.on('-s', '--std_dev') do |std_dev|
      options[:std_dev] = std_dev.to_f
    end
  end.parse!

  return options
end

main(create_options)
