require 'pry'

class EncryptedRoom
  attr_reader :sector_id

  def initialize(code)
    input_chunks = code.gsub(/\W/, ' ').split(' ')
    @checksum = input_chunks.pop
    @sector_id = input_chunks.pop.to_i
    # @encrypted_name = input_chunks.join
    @most_common_letters = analyze_letters(input_chunks.join)
  end

  def analyze_letters(str)
    char_freq = Hash.new(0)
    str.each_char { |c| char_freq[c]+= 1 }
    inverted_freq = {}
    char_freq.each do |k, v|
      if inverted_freq[v].nil?
        inverted_freq[v] = [k]
      else
        inverted_freq[v].push(k)
      end
    end
    letters = []
    keys = inverted_freq.keys.sort.reverse
    keys.each do |k|
      v = inverted_freq[k]
      letters.push(v.sort)
    end
    letters = letters.join
    @most_common_letters = letters[0..4]
  end

  def real?
    @most_common_letters == @checksum
  end
end

class InputReader
  attr_reader :encrypted_rooms

  def initialize(filename)
    @encrypted_rooms = []
    @filename = filename
  end

  def read_file
    File.foreach(@filename) do |line|
      @encrypted_rooms.push(EncryptedRoom.new(line))
    end
  end
end

input = InputReader.new('input.txt')
input.read_file
sector_id_sum = 0
input.encrypted_rooms.each { |room| sector_id_sum += room.sector_id if room.real? }
puts sector_id_sum
