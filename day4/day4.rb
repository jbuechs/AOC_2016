require 'pry'

class EncryptedRoom
  attr_reader :sector_id

  def initialize(code)
    input_chunks = code.gsub(/\W/, ' ').split(' ')
    @checksum = input_chunks.pop
    @sector_id = input_chunks.pop.to_i
    @encoded_name = input_chunks
    @most_common_letters = analyze_letters(input_chunks.join)
  end

  def decoded_name
    decoded_words = []
    delta = @sector_id % 26
    @encoded_name.each do |word|
      letters = word.split('')
      decoded_letters = letters.map do |ch|
        new_ord = ch.ord + delta
        new_ord -= 26 if new_ord > 122
        new_ord.chr
      end
      decoded_word = decoded_letters.join
      decoded_words.push(decoded_word)
    end
    @decoded_name = decoded_words.join(" ")
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
      room = EncryptedRoom.new(line)
      @encrypted_rooms.push(room)
      puts(room.decoded_name, room.sector_id)
    end
  end
end

input = InputReader.new('input.txt')
input.read_file
sector_id_sum = 0
input.encrypted_rooms.each { |room| sector_id_sum += room.sector_id if room.real? }
real_rooms = input.select { |room| room.real? }
real_rooms.each { |room| puts room.decoded_name }
puts sector_id_sum
