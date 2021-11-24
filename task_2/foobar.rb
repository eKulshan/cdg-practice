# frozen_string_literal: true

def foobar
  print 'Please enter first number > '
  first_num = gets.to_i
  print 'Please enter second number > '
  second_num = gets.to_i

  nums = [first_num, second_num]

  nums.include?(20) ? second_num : nums.sum
end
