require 'digest'
STARTING_STRING = '00000'
DOOR_ID = 'uqwqemis'

def find_next_character(start_index)
  hashed_door = ''
  while hashed_door[0..4] != STARTING_STRING do
    hashed_door = Digest::MD5.hexdigest(DOOR_ID + start_index.to_s)
    return { index: start_index, pass_chr: hashed_door[5] } if hashed_door[0..4] == STARTING_STRING
    start_index += 1
  end
end

password = ''
data = find_next_character(0)
password += data[:pass_chr]
7.times do
  data = find_next_character(data[:index] + 1)
  password += data[:pass_chr]
end

puts password
