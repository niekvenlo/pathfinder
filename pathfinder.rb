require_relative "map_parse.rb"

class Stack
  def initialize name=nil
    @name = name || "Stack"
    @array = []
    @sorted = false
  end

  def [] pos
    raise "attempted to seach for non-position" unless pos.class == Integer
    @array.find { |node| node.pos == pos }
  end

  def << node
    raise "attempted to shovel non-node object" unless node.class == Node
    @sorted = false
    @array << node
  end

  def pop
    _sort_cost! unless @sorted
    @array.pop
  end

  def _sort_cost!
    @sorted = true
    @array = @array.sort_by { |el| -(el.g+el.h) }
  end

  def include? node
    raise "attempted to find non-node object" unless node.class == Node
    @array.any? { |el| el.pos == node.pos }
  end

  def to_s
    str = "#{@name.capitalize}:\n"
    @array.each { |el| str << el.to_s << "\n" }
    str
  end
end

class Node
  attr_reader :pos, :g, :h, :parent
  def initialize(pos:, g:, h:, parent: nil)
    @pos    = pos
    @g      = g
    @h      = h
    @cost   = @g + @h
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
    @meta = @map[:meta]
    @frontier = Stack.new("frontier")
    @settled  = Stack.new("settled")
    @start    = start
    @goal     = goal

    raise "start not legal" if @map[start] == nil
    raise "goal not legal" if @map[goal] == nil

    @frontier << Node.new(pos: @start,g: 0, h: calculate_h(@start))
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
                      parent: current.pos,
                      h: calculate_h(n))
      if !@frontier.include? node
        if !@settled.include? node
          @frontier << node
        end
      end
    end
    return false
  end

  def calculate_h n
    columns = @meta[:columns]
    dy = (@goal / (columns+1)) - (n / (columns+1))
    dx = (@goal % (columns+1)) - (n % (columns+1))
    # (Math.sqrt((dx.abs ** 2)+(dy.abs ** 2)).round)*25
    h = (dx.abs+dy.abs)*18
  end

  def found node
    # path = []
    # path << node.pos
    # p @frontier
    # p path
  end

  def neighbors current
    @map[current.pos]
  end

  def show_map
    map_size = @meta[:map_size]
    columns = @meta[:columns]
    map = ""
    0.upto(map_size).each do |n|
      if ((n+1) % (columns+1) == 0)
        map << "\n"
      else
        if @map.key? n
          if @start == n || @goal == n
            symbol = "\e[42m*\e[49m"
          elsif @settled[n]
            symbol = "\e[44m-\e[49m"
          elsif @frontier[n]
            symbol = "\e[45m=\e[49m"
          else
            symbol = "\e[90m-\e[39m"
          end
        else
          symbol = "\e[107m%\e[49m"
        end
        map << symbol
      end
    end
    map
  end
end
# finder = Finder.new(start: 9, goal: 11, map_file: "maps/raw2.txt")
# finder = Finder.new(start: 24, goal: 76, map_file: "maps/raw1.txt")
# finder = Finder.new(start: 44, goal: 470, map_file: "maps/raw4.txt")
# finder = Finder.new(start: 540, goal: 775, map_file: "maps/raw5.txt")
# finder = Finder.new(start: 540, goal: 1020, map_file: "maps/raw5.txt")
# finder = Finder.new(start: 50, goal: 600, map_file: "maps/raw6.txt")
finder = Finder.new(start: 50, goal: 810, map_file: "maps/raw6.txt")
puts finder.show_map
