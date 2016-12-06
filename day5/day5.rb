require 'digest'
require 'pry'
STARTING_STRING = '00000'
DOOR_ID = 'uqwqemis'

class Password
  def initialize
    @pass_loc = -1
    @pass = Array(nil)
    @door_index = 0
  end

  def position_valid?(pos)
    in_range?(pos.to_i) && is_int?(pos)
  end

  def get_password
    @pass[0..7].join
  end

  def not_found?
    get_password.nil? or get_password.length != 8
  end

  def find_next_character
    hashed_door = ''
    new_pass_loc = -1
    until hashed_door[0..4] == STARTING_STRING && position_valid?(new_pass_loc) do
      hashed_door = Digest::MD5.hexdigest(DOOR_ID + @door_index.to_s)
      new_pass_loc = hashed_door[5]
      pass_chr = hashed_door[6]
      if position_valid?(new_pass_loc) && hashed_door[0..4] == STARTING_STRING
        @pass[new_pass_loc.to_i] ||= pass_chr
        @door_index += 1
        return
      end
      @door_index += 1
    end
  end

  private
  def is_int?(chr)
    chr.to_i.to_s == chr
  end

  def in_range?(num)
    num >= 0 && num <= 7
  end
end

password = Password.new
while password.not_found? do
  password.find_next_character
  puts password.get_password
end

puts password.get_password
