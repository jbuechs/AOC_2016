require 'pry'

class Triangle
  attr_reader :sorted_sides

  def initialize(side_arr)
    binding.pry if side_arr.length != 3
    @sides = side_arr.map { |side| side.to_i }
  end

  def valid?
    sorted_sides = @sides.sort
    sorted_sides[0] + sorted_sides[1] > sorted_sides[2]
  end
end

class InputReader
  attr_reader :triangles

  def initialize(filename)
    @triangles = []
    tri_a, tri_b, tri_c = [], [], []
    content = File.readlines(filename)
    content.each_with_index do |line, i|
      line.strip!
      line = line.split(' ')
      if i % 3 == 0 && i != 0
        @triangles.push(Triangle.new(tri_a), Triangle.new(tri_b), Triangle.new(tri_c))
        tri_a, tri_b, tri_c = [], [], []
      end
      tri_c.push(line.pop)
      tri_b.push(line.pop)
      tri_a.push(line.pop)
    end
    @triangles.push(Triangle.new(tri_a), Triangle.new(tri_b), Triangle.new(tri_c))
  end
end

input_reader = InputReader.new('input.txt')
puts input_reader.triangles.count { |tri| tri.valid? }
