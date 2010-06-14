require "set"

class Tree
  
  attr_reader :symbol
  attr_reader :probability
  
  def initialize(symbol, probability)
    @symbol = symbol
    @probability = probability
  end
  
  def <=> other_tree
    other_tree.probability <=> probability
  end
  
  def == other_tree
    symbol == other_tree.symbol
  end
  
  def eql?(o)
    o.is_a?(Tree) && symbol == o.symbol
  end
  
  def hash
    symbol.hash
  end
  
  def to_s
    "#{symbol} (#{probability})"
  end
  
end

# Represents B in the algorithm with capacity 1
class BQueue
  
  attr_reader :s
  attr_reader :e
  attr_accessor :x
  attr_accessor :capacity
  
  def initialize(s,e,x,capacity=1)
    @s = s
    @e = e
    @x = x
    @probability = 0
    @capacity = capacity
    @list = []
  end
  
  def to_s
    #{}"B^[#{@s},#{@e})>#{@x} > tree " + (@tree ? @tree : "NULL") + " (#{probability})"
    "B^[#{@s},#{@e})>#{@x} > " + @list.join("|")
  end
  
  def offer(symbol, probability)
    tree = Tree.new(symbol, probability)
    
    # If tree already exist, ignore offer
    return if @list.include? tree
    
    if @list.length < @capacity
      # Add to set - has space for adding
      @list.push(tree)
    elsif
      # Got to the max capacity
      # Tree does not exist in set
      # Check if tree.probability > some tree probability in set and which one it is
      # Drop the lowest probability and add the new tree
      if @list.last.probability < tree.probability
        @list.pop
        @list.push(tree)
      end
    end
    
    # Sort - from high probability to lowest
    @list.sort!
    
  end
  
  def pop
    # Retrieve the highest probability tree and delete it from array
    tree = @list.slice!(0)
    [tree.symbol, tree.probability]
  end
  
end