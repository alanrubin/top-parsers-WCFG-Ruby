# Represents B in the algorithm with capacity 1
class BQueue
  
  attr_reader :s
  attr_reader :e
  attr_accessor :x
  attr_accessor :tree
  attr_accessor :probability
  
  def initialize(s,e,x,capacity)
    @s = s
    @e = e
    @x = x
    @probability = 0
  end
  
  def to_s
    "B^[#{@s},#{@e})>#{@x} " + (@tree ? @tree : "NULL") + " (#{probability})"
  end
  
  def offer(tree, probability)
    if(probability >= @probability)
      @probability = probability
      @tree = tree
    end
  end
  
  def pop
    out = [@tree,@probability]
    @probability = 0
    @tree = nil  
    out
  end
  
end