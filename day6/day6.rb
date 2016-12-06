require 'pry'

class MessageReader
  def initialize(init_object)
    @filename = init_object[:filename]
    @column_counter = init_object[:column_counter]
  end

  def read_file
    File.foreach(@filename) do |line|
      @column_counter.update_column_stats(line)
    end
  end
end

class ColumnCounter
  attr_reader :column_stats
  def initialize(num_col)
    @num_col = num_col
    @column_stats = init_column_stats
  end

  def init_column_stats
    column_stats = {}
    @num_col.times do |n|
      column_stats[n] = []
    end
    column_stats
  end

  def update_column_stats(corrupted_code)
    @num_col.times do |n|
      char = corrupted_code[n]
      @column_stats[n].push(char)
    end
  end

  def decoded_message
    message = ""
    @num_col.times do |n|
      message += find_mode(@column_stats[n])
    end
    message
  end

  def second_decoded_message
    message = ""
    @num_col.times do |n|
      message += find_least_frequent(@column_stats[n])
    end
    message
  end

  def find_mode(arr)
    grouped_arr = arr.group_by { |ch| ch}
    mode_arr = grouped_arr.values.max_by { |ch_arr| ch_arr.length }
    mode_arr[0]
  end

  def find_least_frequent(arr)
    grouped_arr = arr.group_by { |ch| ch}
    min_arr = grouped_arr.values.min_by { |ch_arr| ch_arr.length }
    min_arr[0]
  end
end

column_counter = ColumnCounter.new(8)

init_object = {
  filename: 'input.txt',
  column_counter: column_counter
}
message_reader = MessageReader.new(init_object)
message_reader.read_file

puts column_counter.second_decoded_message
