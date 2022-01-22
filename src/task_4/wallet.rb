# frozen_string_literal: true
require 'pry'

def get_message(name, data = nil)
  messages = {
    manual: ['Please choose an action:',
             '  - H(h) - show manual',
             '  - B(b) - show balance',
             '  - D(d) - deposit money',
             '  - W(w) - withdraw money',
             '  - Q(q) - save balance and quit'].join("\n"),
    action: 'Enter action please >',
    balance: "Your balance is #{data}$",
    deposit_tip: 'Please enter value greater than 0 or type -1 for exit from transaction >',
    withdraw_tip: ["Please enter value between 0 and #{data}.",
                   'Or enter -1 for exit from transaction >'].join("\n"),
    deposited: "Deposited #{data}$",
    withdrawed: "Withdrawed #{data}$",
    no_action_tip: "There is no such action as '#{data}'. Please refer to manual(h) for help."
  }
  messages[name]
end

BALANCE = 100.0

def wallet(balanse_file_dir = __dir__)
  balanse_file_path = File.join(balanse_file_dir, 'balance.txt')
  balance_file = if File.exist?(balanse_file_path)
                   File.open(balanse_file_path,
                             'r+')
                 else
                   File.open(balanse_file_path, 'w+')
                 end
  balance = File.empty?(balance_file) ? BALANCE : File.read(balanse_file_path).to_f

  puts 'Welcome to Wallet! To see help type - h.'

  loop do
    puts get_message(:action)
    action = gets.chomp.downcase
    value = 0

    case action
    when 'h'
      puts get_message(:manual)
    when 'b'
      puts get_message(:balance, balance)
    when 'd'
      until value == -1 || value.positive?
        puts get_message(:deposit_tip)
        value = gets.to_f
      end
      next if value == -1

      balance += value
      puts get_message(:deposited, value)
      puts get_message(:balance, balance)
    when 'w'

      until value == -1 || value.between?(0.01, balance)
        puts get_message(:withdraw_tip, balance)
        value = gets.to_f
      end
      next if value == -1

      balance -= value
      puts get_message(:withdrawed, value)
      puts get_message(:balance, balance)
    when 'q'
      File.write(balanse_file_path, balance)
      break
    else
      puts get_message(:no_action_tip, action)
    end
  end
end

# wallet
