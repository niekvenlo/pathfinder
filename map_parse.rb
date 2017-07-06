class MapParse
  def self.parse_raw map
    @map = File.readlines(map).join
    @map_size = @map.length
    @line_length = @map.index("\n")+1
    @regex = /[%\s]/
    @output = {}
    @map.chars.each_with_index do |ch,idx|
      @output[idx] = neighbors(idx) unless ch =~ @regex
    end
    @output
  end

  def self.neighbors pos
    return false if @map[pos] =~ @regex
    vertical = [pos-@line_length,pos+@line_length]
    horizontal = [pos-1,pos+1]
    vertical.reject! { |nei| nei < 0 || nei > @map_size }
    horizontal.reject! { |nei| nei/@line_length != pos/@line_length }
    (vertical+horizontal).reject { |nei| @map[nei] =~ @regex}.sort
  end

end
