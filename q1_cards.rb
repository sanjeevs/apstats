require 'pp'
require 'optparse'
require 'ostruct'
require_relative 'stats'
require_relative 'sample_distrib'

def main(options)

  sample_stats = run_sample_trials(options)

  pp "Experimental Mean number of diamonds in a sample of #{options[:num_samples]} is  #{sample_stats.mean}"
  pp "Experimental Std dev number of diamonds in  a sample of #{options[:num_samples]} is  #{sample_stats.std_dev}"
  puts "======"
 
  exp_stats = compute_expected_stats(options[:num_samples])

  pp "Expected number of diamonds in the sample size #{options[:num_samples]} is #{exp_stats.mean}"
  pp "Expected std_dev of diamonds in the sample size #{options[:num_samples]} is #{exp_stats.std_dev}"
  
end

# Run trials to compute the sample values
def run_sample_trials(options)
  result = []
  freq_diamonds = Hash.new(0)
  
  cards = create_deck_of_cards

  options[:num_trials].times do |i|
    num_diamonds = run_trial(options[:num_samples], cards)
    freq_diamonds[num_diamonds] += 1 
    result << num_diamonds
  end

  if(options[:result_file])
    File.open(options[:result_file], "w") do |fh|
      fh.puts "#NumDiamonds NumTimes"
      freq_diamonds.sort_by {|key, value| key}.each do |v|
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
def run_trial(num_samples, cards)
  num_diamonds = 0
  num_samples.times do 
    idx = rand(cards.size).to_i
    num_diamonds += is_type_diamond(cards[idx])
  end
  num_diamonds
end

def compute_expected_stats(num_samples)
  population_stats = run_population_trials
  expected_stats = OpenStruct.new
  expected_stats.mean = SampleDistrib::mean(population_stats.mean)
  expected_stats.std_dev = SampleDistrib::std_dev(population_stats.prob_of_success,
                                                 num_samples)
  return expected_stats
end

# Run trials on the population to compute the true values.
def run_population_trials(num_trials=1000000)
  result = []

  cards = create_deck_of_cards

  num_trials.times do
    idx = rand(cards.size).to_i
    result <<  is_type_diamond(cards[idx])
  end

  stats = OpenStruct.new 
  stats.prob_of_success = result.mean
  stats.std_dev = result.std_dev
  return stats
end

def is_type_diamond(card)
  (card < 13) ? 1 : 0
end

def create_deck_of_cards
  cards = []
  52.times do |i|
    cards << i
  end
  cards.shuffle
end

def create_options
  options = {num_samples: 5, num_trials: 1000000, result_file: nil}
  
  parser = OptionParser.new do |opts|
    opts.banner = <<EOF
In a deck of cards, take a sample of say 'n' cards.
Compute the mean and std dev of getting a diamond in the sample.
Usage: q1_cards.rb [options]
EOF
    opts.on('-n', '--num_samples') do |num_samples|
      options[:num_samples] = num_samples
    end
    opts.on('-t', '--num_trials') do |num_trials|
      options[:num_trials] = num_trials
    end
    opts.on('-o', '--output') do |reuslt_file|
      options[:result_file] = result_file 
    end
  end.parse!

  return options
end

main(create_options)

