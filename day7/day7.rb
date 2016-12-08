require 'set'

class IPV7
  def initialize(str)
    @hypernet_sequences, @other_sequences = split_string(str)
    @aba_sequences = Set.new
    @aba_matches = Set.new
    @bab_sequences = []
  end

  def split_string(str)
    sequences = str.split(/\W/)
    other_sequences = []
    hypernet_sequences = []
    sequences.length.times do |i|
      if i % 2 == 0
        other_sequences.push(sequences[i])
      else
        hypernet_sequences.push(sequences[i])
      end
    end
    return hypernet_sequences, other_sequences
  end

  def find_abas(seq)
    (seq.length - 2).times do |i|
      substring = seq[i..i+2]
      if is_abba?(substring)
        @aba_sequences.add(substring)
        @aba_matches.add(substring[1..2]+substring[1])
      end
    end
  end

  def supports_ssl?
    @other_sequences.each do |seq|
      find_abas(seq)
    end
    @hypernet_sequences.each do |seq|
      (seq.length - 2).times do |i|
        substring = seq[i..i+2]
        return true if is_abba?(substring) and @aba_matches.include?(substring)
      end
    end
    false
  end

  def contains_abba?(seq)
    (seq.length - 3).times {|i| return true if is_abba?(seq[i..i+3]) }
    false
  end

  def is_abba?(chars)
    # puts "Invalid number of chars in #{four_chars}" if four_chars.length != 4
    chars[0] != chars[1] && chars == chars.reverse
  end

  def supports_tls?
    @hypernet_sequences.all? { |hs| !contains_abba?(hs) } && @other_sequences.any? { |os| contains_abba?(os) }
  end
end


class InputReader
  attr_reader :ips

  def initialize(filename)
    @filename = filename
    @ips = []
  end

  def read_file
    File.foreach(@filename) do |line|
      @ips.push(IPV7.new(line))
    end
  end
end

ir = InputReader.new('input.txt')
ir.read_file

# puts ir.ips.count { |ip| ip.supports_tls? }
puts ir.ips.count { |ip| ip.supports_ssl? }
