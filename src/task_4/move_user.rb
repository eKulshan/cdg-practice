# frozen_string_literal: true

def get_message(name, data = nil)
  messages = {
    actions_tip: '==> Type "a" to see all users or "q" to exit.',
    request_age: '==> Please enter user age >',
    wrong_user_age: "==> There is no user with age #{data}.",
    request_matched_user_id: '==> Please choose which user to move. Enter user number >',
    wrong_user_id: "==> There is no user with number #{data}",
    users: "==> Users (#{data}) <==",
    matched_users: "==> Matched users (#{data}) <==",
    moved_users: "==> Moved users (#{data}) <=="
  }
  messages[name]
end

def move_users(source, destination)
  users = File.read(source).split("\n")
  moved_counter = 0

  puts get_message(:actions_tip)
  until users.empty?
    puts get_message(:request_age)
    input = gets.chomp

    case input
    when 'q'
      break
    when 'a'
      puts get_message(:users, users.size)
      puts users
      next
    else
      matched_users = users.filter { |user| user[-2, 2] == input }

      if matched_users.empty?
        puts get_message(:wrong_user_age, input)
        puts get_message(:actions_tip)
        next
      end

      if matched_users.length > 1
        puts get_message(:matched_users, matched_users.size)
        puts matched_users
        puts get_message(:request_matched_user_id)
        user_number = gets.to_i
        until user_number.between?(0, matched_users.size)
          puts get_message(:wrong_user_id, user_number)
          puts get_message(:matched_users, matched_users.size)
          puts matched_users
          puts get_message(:request_matched_user_id)
          user_number = gets.to_i
        end
        File.write(destination, "#{users.delete(matched_users[user_number - 1])}\n", mode: 'a')
        moved_counter += 1
        next
      end

      File.write(destination, "#{users.delete(matched_users.first)}\n", mode: 'a')
      moved_counter += 1
    end
  end
  moved_users = File.read(destination).split("\n").last(moved_counter)
  puts get_message(:moved_users, moved_users.size)
  puts moved_users
end