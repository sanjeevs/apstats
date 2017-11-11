module SampleDistrib 
  def self.mean(population_mean)
    return population_mean
  end

  def self.std_dev(p, num_samples)
    return Math.sqrt((p * (1-p))/num_samples)
  end

end

