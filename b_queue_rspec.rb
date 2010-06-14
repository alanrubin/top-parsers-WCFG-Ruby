require "b_queue"
require "context_free_rule"

describe BQueue, "when created" do
  
  it "should present the correct string representation" do
    b1 = BQueue.new 1,2,"AU"
    b2 = BQueue.new 1,5,"TS"
    b3 = BQueue.new 1,5,"TS",2
    b2.offer("A(B)",0.5)
    b3.offer("A1(B1)",0.3)
    b3.offer("A2(B2)",0.5)
    
    b1.to_s.should eql "B^[1,2)>AU > "
    b2.to_s.should eql "B^[1,5)>TS > A(B) (0.5)"
    b3.to_s.should eql "B^[1,5)>TS > A2(B2) (0.5)|A1(B1) (0.3)"
  end
  
  it "should accept offer at initial state and capacity 1" do
    b1 = BQueue.new 1,2,"AU"
    b1.offer("A(B)",0.5)
    t = b1.pop
    t.should eql ["A(B)",0.5]
  end
  
  it "should accept offer with higher probability and capacity 1" do
    b1 = BQueue.new 1,2,"AU"
    b1.offer("A(B)",0.5)
    b1.offer("A2(B2)",0.9)
    t = b1.pop
    t.should eql ["A2(B2)",0.9]
  end
  
  it "should decline offer with lower probability and capacity 1" do
    b1 = BQueue.new 1,2,"AU"
    b1.offer("A(B)",0.5)
    b1.offer("A-1(B-1)",0.2)
    t = b1.pop
    t.should eql ["A(B)",0.5]
  end
  
  it "should accept offer at initial state and capacity 2 and retrieve top result" do
    b1 = BQueue.new 1,2,"AU",2
    b1.offer("A(B)",0.5)
    b1.offer("A2(B2)",0.4)
    t = b1.pop
    t.should eql ["A(B)",0.5]
    t = b1.pop
    t.should eql ["A2(B2)",0.4]
  end
  
  it "should accept offers and drop worst already stored" do
    b1 = BQueue.new 1,2,"AU",2
    b1.offer("A2(B2)",0.4)
    b1.offer("A(B)",0.5)
    b1.offer("A3(B3)",0.2)
    t = b1.pop
    t.should eql ["A(B)",0.5]
    t = b1.pop
    t.should eql ["A2(B2)",0.4]
  end
  
  it "should decline offer with already existing t" do
    b1 = BQueue.new 1,2,"AU"
    b1.offer("A(B)",0.5)
    b1.offer("A(B)",0.7)
    t = b1.pop
    t.should eql ["A(B)",0.5]
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