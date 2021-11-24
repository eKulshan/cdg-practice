# frozen_string_literal: true

def greeting
  print 'Please enter your first name > '
  first_name = gets.chomp
  print 'Please enter your last name > '
  last_name = gets.chomp
  print 'Please enter your age > '
  age = gets.to_i

  young_message = "Hello, #{first_name} #{last_name}! " \
                  'You are younger than 18 but learning programming is never too early.'
  adult_message = "Hello, #{first_name} #{last_name}! Let's get down to business!"

  age < 18 ? young_message : adult_message
end
