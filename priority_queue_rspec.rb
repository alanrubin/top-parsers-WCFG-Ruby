require "priority_queue"
require "context_free_rule"

describe PriorityQueue, "when created" do
  it "should present the correct string representation" do
    b1 = PriorityQueue.new 1,2,"AU"
    b2 = PriorityQueue.new 1,5,"TS"
    b1.to_s.should eql "B^[1,2)>AU"
    b2.to_s.should eql "B^[1,5)>TS"
  end
end

describe ContextFreeRule, "when created" do
  it "should be initialized with from, to and probability" do
    cfg = ContextFreeRule.new "S",["BK"],0.6
    cfg.from.should eql "S"
    cfg.to.should eql ["BK"]
    cfg.probability.should eql 0.6
  end
  it "should present the correct string representation" do
    cfg1 = ContextFreeRule.new "S",["BK"],0.6
    cfg2 = ContextFreeRule.new "S",["BK","AUS"],0.6
    cfg1.to_s.should eql "S -> BK (0.6)"
    cfg2.to_s.should eql "S -> BK AUS (0.6)"
  end
end