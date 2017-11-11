require 'minitest/autorun'
require_relative "random_gaussian"
require_relative "stats"

class TestRandomGaussian < MiniTest::Test
  def setup
    @delta = 0.01
    @num_times = 1000000
  end

  def test_normal
    result = []
    normal_rg = RandomGaussian.new(0, 1)
    @num_times.times do 
      result << normal_rg.rand
    end
    assert_in_delta(result.mean, 0, @delta)
    assert_in_delta(result.std_dev, 1, @delta)
  end

  def test_protozoan
    mean = 46.7
    stddev = 3.2
    rg = RandomGaussian.new(mean, stddev)
    result = rg.population(@num_times)
    assert_in_delta(result.mean, mean, @delta)
    assert_in_delta(result.std_dev, stddev, @delta)
  end


end

