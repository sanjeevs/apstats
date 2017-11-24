module Stats
  def sum(&blk)
    map(&blk).inject { |sum, element| sum + element}
  end

  def mean
    (sum.to_f / size.to_f)
  end

  def variance
    m = mean
    sum { |i| (i - m)**2 } /size
  end

  def std_dev
    Math.sqrt(variance)
  end

  def median
    sorted_arr = self.sort
    if (size % 2) == 1
      sorted_arr.send(:[], size/2)
    else
      idx = size/2
      (sorted_arr.send(:[], idx-1) + sorted_arr.send(:[], idx))/2.0 
    end
  end

end
Array.send :include, Stats

