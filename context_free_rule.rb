class ContextFreeRule
  attr_reader :from
  attr_reader :to
  attr_reader :probability
  
  def initialize(from,to,probability)
    @from = from
    @to = to
    @probability = probability
  end
  
  def to_s
    "#{@from} -> #{@to.join(' ')} (#{@probability})"
  end
  
end