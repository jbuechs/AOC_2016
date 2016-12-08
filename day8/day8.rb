require 'pry'

class Screen
  attr_reader :screen

  def initialize(dimensions)
    @width = dimensions[:width]
    @height = dimensions[:height]
    @screen = Array.new(@height){Array.new(@width)}
  end

  def print_screen
    @height.times do |y|
      @width.times do |x|
        print @screen[y][x] ? 'o' : '-'
      end
      puts
    end
  end

  def replace_column(x, new_column)
    @height.times do |i|
      @screen[i][x] = new_column[i]
    end
  end

  def replace_row(y, new_column)
    @screen[y] = new_column
  end

  def get_column(x)
    col = []
    @height.times do |i|
      col.push(@screen[i][x])
    end
    col
  end

  def get_row(y)
    @screen[y]
  end

  def rotate_column(x, delta)
    old_col = get_column(x)
    new_col = old_col[-delta..-1] + old_col[0..-delta - 1]
    replace_column(x, new_col)
  end

  def rotate_row(y, delta)
    old_row = get_row(y)
    new_row = old_row[-delta..-1] + old_row[0..-delta - 1]
    replace_row(y, new_row)
  end

  def draw_rect(w, h)
    h.times do |y|
      w.times do |x|
        @screen[y][x] = true
      end
    end
  end

  def num_pixels_on
    num_by_row = @screen.map { |row| row.count(true) }
    num_by_row.inject(:+)
  end
end


class InputReader
  attr_reader :screen

  def initialize(filename, dimensions)
    @filename = filename
    @screen = Screen.new(dimensions)
  end

  def read_file
    File.foreach(@filename) do |line|
      parse_command(line.strip)
      # puts line.strip
      # @screen.print_screen
      # gets
    end
  end

  def parse_rect(command)
    command = command.split(/[x]|\s/)
    return command[-2].to_i, command[-1].to_i
  end

  def parse_rotate(command)
    num2 = command.split(' ')[-1].to_i
    command = command[0..-4]
    num1 = command.gsub(/\D/, '').to_i
    return num1, num2
  end

  def parse_command(command)
    if command.match('rect')
      w, h = parse_rect(command)
      @screen.draw_rect(w, h)
    else
      num1, num2 = parse_rotate(command)
      if command.match('row')
        @screen.rotate_row(num1, num2)
      elsif command.match('column')
        @screen.rotate_column(num1, num2)
      end
    end
  end
end

# ir = InputReader.new('short_input.txt', {width: 7, height: 3})
ir = InputReader.new('input.txt', {width: 50, height: 6})

ir.read_file
ir.screen.print_screen
puts ir.screen.num_pixels_on
