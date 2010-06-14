require "priority_queue"
require "context_free_rule"

# Convert w to array of words
w = "virgina woolf orlando biography".scan(/\w+/)
k = 1

# creating the WCFG rules array
T = []
T << ContextFreeRule.new("S",["BK"],0.6)
T << ContextFreeRule.new("S",["AUS"],0.3)
T << ContextFreeRule.new("S",["GNR"],0.1)

T << ContextFreeRule.new("BK",["AUS","TD"],0.3)
T << ContextFreeRule.new("BK",["TD","AUS"],0.2)
T << ContextFreeRule.new("BK",["AUS","GNR"],0.4)
T << ContextFreeRule.new("BK",["GNR","AUS"],0.1)

T << ContextFreeRule.new("AUS",["AUS","AU"],0.6)
T << ContextFreeRule.new("AUS",["EMPTY"],0.4)

T << ContextFreeRule.new("TD",["TL"],0.4)
T << ContextFreeRule.new("TD",["KWS"],0.6)

T << ContextFreeRule.new("TL",["orlando","biography"],0.1)
T << ContextFreeRule.new("TL",["little","women"],0.9)

T << ContextFreeRule.new("KWS",["KW"],0.5)
T << ContextFreeRule.new("KWS",["KW","KWS"],0.5)

T << ContextFreeRule.new("KW",["women"],0.4)
T << ContextFreeRule.new("KW",["orlando"],0.1)
T << ContextFreeRule.new("KW",["biography"],0.5)

T << ContextFreeRule.new("GNR",["mistery"],0.2)
T << ContextFreeRule.new("GNR",["fiction"],0.4)
T << ContextFreeRule.new("GNR",["biography"],0.3)
T << ContextFreeRule.new("GNR",["poetry"],0.1)

T << ContextFreeRule.new("AU",["virgina","woolf"],0.2)
T << ContextFreeRule.new("AU",["woolf"],0.2)
T << ContextFreeRule.new("AU",["jessica","orlando"],0.1)
T << ContextFreeRule.new("AU",["orlando"],0.2)
T << ContextFreeRule.new("AU",["louisa","V"],0.3)

T << ContextFreeRule.new("V",["may","alcott"],1)

# Create Non-Terminals unique array (non-terminal list)
NT = T.map { |rule| rule.from }.uniq

# Create X -> e (empty) list
TEmpty = T.select {|cfg| cfg.to==["EMPTY"]}

# l_sorted - empty stored list
$l_sorted = []

def find_in_L(s,e,x)
  return $l_sorted.select{ |b| b.s==s && b.e==e && b.x==x  }[0]
end

def find_in_Fs(s,e,x)
  return Fs.select{ |b| b.s==s && b.e==e && b.x==x  }[0]
end

# Fs - stores the F
Fs = []

#### Initialize the data structures ####

# Creating the B^{s,e)>X and B^{s,e)>Ws and inserting into L - Line 2-8
(NT+w).each do |x|
  (1..(w.length+1)).each do |s|
    (s..(w.length+1)).each do |e|
      $l_sorted << PriorityQueue.new(s,e,x,k)
      Fs << PriorityQueue.new(s,e,x,k)
    end
  end
end

# Offering the B^{s,e)>Ws with probability 1
(1..w.length).each do |s|
  e = s+1
  b = find_in_L(s,e,w[s-1]) 
  b.offer(w[s-1],1)
end

# Offering the B^{s,s)>X -> Empty with defined probability
(1..(w.length+1)).each do |s|
  TEmpty.each do |x|
    b = find_in_L(s,s,x.from) 
    b.offer(x.from,x.probability)
  end
end

# Sorting L by highest probabilities
$l_sorted = $l_sorted.sort_by{ |b| 1-b.probability }

# $l_sorted.each do |b|
#  p b.to_s
# end

# exit

### Repeat: top, pop and update
result = []
i=0

while result.length < k
  b = $l_sorted.first
  #p b.to_s
  break if(b.tree==nil)
  t = b.pop
  # What's the importance of f ?
  find_in_Fs(b.s,b.e,b.x).insert(t)
  result << t if b.x == "S" && b.s == 1 && b.e == (w.length+1)
  # X -> A
  T.select { |cfg| cfg.to == [b.x] }.each do |cfg|
    find_in_L(b.s,b.e,cfg.from).offer("#{cfg.from}(#{t[0]})",cfg.probability*t[1])
  end
  # X -> A0 A
  T.select { |cfg| cfg.to.length == 2 && cfg.to[1] == b.x }.each do |cfg|
    (1..b.s).each do |s_apos|
      t_a0 = []
      b_a0 = find_in_L(s_apos,b.s,cfg.to[0])
      f_a0 = find_in_Fs(s_apos,b.s,cfg.to[0])
      t_a0 << b_a0.get if(b_a0 && b_a0.get)
      (t_a0 + f_a0.list) if(f_a0 && !f_a0.list.empty?)
      
      t_a0.each do |t0|
        find_in_L(s_apos,b.e,cfg.from).offer("#{cfg.from}(#{t0[0]},#{t[0]})",t0[1]*t[1])
      end
    end
  end
  # X -> A A0
  T.select { |cfg| cfg.to.length == 2 && cfg.to[0] == b.x }.each do |cfg|
    (b.e..(w.length+1)).each do |e_apos|
      t_a0 = []
      b_a0 = find_in_L(b.e,e_apos,cfg.to[1])
      f_a0 = find_in_Fs(b.e,e_apos,cfg.to[1])
      t_a0 << b_a0.get if(b_a0 && b_a0.get)
      (t_a0 + f_a0.list) if(f_a0 && !f_a0.list.empty?)
      
      t_a0.each do |t0|
        find_in_L(b.s,e_apos,cfg.from).offer("#{cfg.from}(#{t[0]},#{t0[0]})",t0[1]*t[1])
      end
    end
  end
  
  # Sorting
  $l_sorted = $l_sorted.sort_by{ |b| 1-b.probability }
  
  i = i+1
end

# $l_sorted.each do |b|
#  p b.to_s
# end
p i
p result








