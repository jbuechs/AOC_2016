require 'digest'
require 'pry'
STARTING_STRING = '00000'
DOOR_ID = 'uqwqemis'

def find_next_character(start_index)
  hashed_door = ''
  while hashed_door[0..4] != STARTING_STRING do
    hashed_door = Digest::MD5.hexdigest(DOOR_ID + start_index.to_s)
    return { index: start_index, pass_chr: hashed_door[6], pass_loc: hashed_door[5].to_i } if hashed_door[0..4] == STARTING_STRING
    start_index += 1
  end
end

password = Array(nil)
data = find_next_character(0)
password[data[:pass_loc]] ||= data[:pass_chr]
while !password[0].nil? && !password[1].nil? && !password[2].nil? && !password[3].nil? && !password[4].nil? && !password[5].nil? && !password[6].nil? && !password[7].nil? do
  data = find_next_character(data[:index] + 1)
  binding.pry
  password[data[:pass_loc]] ||= data[:pass_chr]
end

puts password[0..7]
