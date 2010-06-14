require "set"
require "b_queue"

class MyCl
  
  attr_reader :value
  
  def initialize(value)
    @value = value
  end
  
  def <=> comp
    @value <=> comp.value
  end
  
  # def eql?(o)
  #   o.is_a?(MyClass) && str == o.str
  # end
  # 
  # def hash
  #   @str.hash
  # end
  
end

# ordered = SortedSet.new([MyCl.new(3),MyCl.new(1),MyCl.new(4),MyCl.new(0)])
# ordered.add(MyCl.new(2))
# p ordered.to_a
# p ordered.
# p ordered.length

t1 = Tree.new("AB",0.5)
t2 = Tree.new("AB",0.9)

p [t1].include? t2