class MapParse
  def self.parse_raw map_path
    @raw_map = File.readlines(map_path).join
    @raw_map_size = @raw_map.size
    @cols = @raw_map.index("\n")
    @rows = @raw_map_size / @cols
    @regex = /[%#\s]/
    map_info =  { file_path: map_path,
                  map_size: @raw_map_size,
                  columns: @cols,
                  rows: @rows
    }
    @adjacency_map = { meta: map_info }
    @raw_map.chars.each_with_index do |ch,idx|
      @adjacency_map[idx] = neighbors(idx) unless ch =~ @regex
    end
    @adjacency_map
  end

  def self.neighbors pos
    return false if @raw_map[pos] =~ @regex
    vertical = [pos-@cols,pos+@cols]
    horizontal = [pos-1,pos+1]
    vertical.reject! { |nei| nei < 0 || nei > @raw_map_size }
    horizontal.reject! { |nei| nei/(@cols+1) != pos/(@cols+1) }
    (vertical+horizontal).reject { |nei| @raw_map[nei] =~ @regex}.sort
  end
end
