require_relative "map_parse.rb"

class Stack
  def initialize(name)
    @name = name
    @array = []
  end

  def <<(node)
    @array << node
  end

  def sort_cost!
    @array = @array.sort_by { |el| -el.g }
  end

  def pop
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
    current = @frontier.sort_cost!.pop
    if current.pos == @goal
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
    puts @frontier
    puts @settled
    puts "\n"
    return false
  end

  def found current
    puts "FOUND:"
    puts current
  end

  def neighbors(current)
    @map[current.pos]
  end

end

finder = Finder.new(start: 9, goal: 11, map_file: "maps/raw2.txt")
finder = Finder.new(start: 24, goal: 76, map_file: "maps/raw1.txt")
