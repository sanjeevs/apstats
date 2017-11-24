require 'minitest/autorun'
require_relative 'stats'

class TestStats < MiniTest::Test

  def test_median_odd
    arr = [1, 2, 3]
    assert_equal(2, arr.median)
  end
  
  def test_median_unsorted
    arr = [3, 1, 2]
    assert_equal(2, arr.median)
  end
  
  def test_median_even
    arr = [1, 2, 3, 4]
    assert_equal(2.5, arr.median)
  end
  
  def test_failure1
    arr = [5,10,10,15,15,15,15,20,20,20,25,30,30,40,40,45,60,60,65,85]
    assert_equal(22.5, arr.median)
  end

end

