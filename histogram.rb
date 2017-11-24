class Histogram
  def initialize(&block)
    @hash = Hash.new(0)
    @sorted_arr = []
    @is_sorted = false
    @key_gen = block 
  end

  def add(v)
    if v.kind_of?(Array)
      v.map {|i| add(i) }
    else
      v = @key_gen.call(v) if @key_gen
      @hash[v] += 1
    end
  end

  def max_freq
    @sorted_arr = @hash.sort_by {|k, v| v} unless @is_sorted
    @is_sorted = true
    return [@sorted_arr[-1][0], @sorted_arr[-1][1]]
  end

  def dump(filename)
    key_arr = @hash.sort_by {|k, v| k} 
    File.open(filename, "w") do |fh|
      key_arr.each {|v| fh.puts("#{v[0]}\t#{v[1]}") }
    end
  end

  def clear
    @hash.clear
    @sorted_arr = []
    @is_sorted = false
  end

end
    
