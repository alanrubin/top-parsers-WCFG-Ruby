# Represents B in the algorithm with capacity 1
class PriorityQueue
  
  attr_reader :s
  attr_reader :e
  attr_accessor :x
  attr_accessor :tree
  attr_accessor :probability
  attr_accessor :capacity
  attr_reader :list
  
  def initialize(s,e,x,capacity)
    @s = s
    @e = e
    @x = x
    @probability = 0
    @capacity = capacity
    @list = []
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
  
  def get
    [@tree,@probability] if(@tree)
  end
  
  def insert(t)
    @list.push t
  end
  
end