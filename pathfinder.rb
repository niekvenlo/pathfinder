require_relative "map_parse.rb"

class Stack
  def initialize(name=nil)
    @name = name || "Stack"
    @array = []
  end

  def [](node)
    @array[node]
  end

  def <<(node)
    @array << node
  end

  def sort_cost!
    @array = @array.sort_by { |el| -el.g }
  end

  def pop
    sort_cost!
    @array.pop
  end

  def include?(node)
    @array.any? { |el| el.pos == node.pos }
  end

  def to_s
    str = "#{@name.capitalize}:\n"
    @array.each { |el| str << el.to_s << "\n" }
    str
  end
end

class Node
  attr_reader :pos, :g, :parent
  def initialize(pos:, g:, parent: nil)
    @pos    = pos
    @g      = g
    @parent = parent
  end

  def to_s
    "pos #{@pos}, g:#{@g}, parent: #{@parent}"
  end
end

class Finder
  attr_reader :map
  def initialize(start:, goal:, map_file:)
    @map = MapParse::parse_raw(map_file)
    @frontier = Stack.new("frontier")
    @settled  = Stack.new("settled")
    @start    = start
    @goal     = goal

    raise "start not legal" if @map[start] == nil
    raise "goal not legal" if @map[goal] == nil

    @frontier << Node.new(pos: @start,g: 0)
    until explore
    end
  end

  def explore
    current = @frontier.pop
    if current.pos == @goal
      @settled << current
      found current
      return current
    end
    @settled << current
    neighbors(current).each do |n|
      node = Node.new(pos: n,
                      g: current.g+10,
                      parent: current.pos)
      if !@frontier.include?(node)
        if !@settled.include?(node)
          @frontier << node
        end
      end
    end
    return false
  end

  def found current
    # puts @frontier
    # puts "FOUND: #{current}"
  end

  def neighbors(current)
    @map[current.pos]
  end

  def show_map
    meta = @map[:meta]
    map_size = meta[:map_size]
    # rows = meta[:rows]
    p columns = meta[:columns]
    map = ""
    0.upto(map_size).each do |n|
      map << (@map.key?(n) ? "-" : "%")
      map << "\n" if ((n+1) % (columns+1) == 0)
    end
    map
  end
end
# finder = Finder.new(start: 9, goal: 11, map_file: "maps/raw2.txt")
# finder = Finder.new(start: 24, goal: 76, map_file: "maps/raw1.txt")
# finder = Finder.new(start: 44, goal: 470, map_file: "maps/raw4.txt")
finder = Finder.new(start: 540, goal: 775, map_file: "maps/raw5.txt")
puts finder.show_map