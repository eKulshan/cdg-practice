# frozen_string_literal: true

require 'pry'
require 'json'

# Supplying messages to display to the client
module Messages
  @messages = {
    hello: -> { 'Welcome to Wallet! To see help type - h.' },
    manual: lambda do
      [
        'Please choose an action:',
        '  - h[H]: show manual',
        '  - b[B]: show balance',
        '  - d[D]: deposit money',
        '  - w[W]: withdraw money',
        '  - q[Q]: save balance and quit'
      ].join("\n")
    end,
    action: -> { 'Enter action please:' },
    balance: ->(data) { "Your balance is #{data}$" },
    deposit_tip: -> { "Please enter value greater than 0 or type '-1' for exit from transaction:" },
    withdraw_tip: ->(data) { "Please enter value between 0 and #{data}. Or enter '-1' for exit from transaction:" },
    deposited: ->(data) { "Deposited #{data}$" },
    withdrawed: ->(data) { "Withdrawed #{data}$" },
    no_action_tip: ->(data) { "There is no such action as '#{data}'. Please refer to manual(h) for help." },
    goodbye: -> { 'Goodbye!' }
  }

  def self.get_message(name, data = nil)
    data.nil? ? @messages[name].call : @messages[name].call(data)
  end
end

# Allows client interact with his account
class CashMachine
  include Messages

  def initialize(balance_file_path)
    @balance_file = if File.exist?(balance_file_path)
                      File.open(balance_file_path, 'r+')
                    else
                      File.open(File.join(__dir__, 'balance.txt'), 'w+')
                    end
    @balance = File.empty?(@balance_file) ? 100.0 : File.read(@balance_file.path).to_f
  end

  def init
    puts Messages.get_message(:hello)

    loop do
      puts Messages.get_message(:action)
      action = gets.chomp.downcase
      @value = 0
      if action == 'q'
        make_action(action)
        puts Messages.get_message(:goodbye)
        break
      end
      make_action(action)
    end
  end

  protected

  def make_action(action)
    available_actions = %i[h b d w q]
    unless available_actions.include?(action.to_sym)
      puts Messages.get_message(:no_action_tip, action)
      return
    end
    method(action.to_sym).call
  end

  def help
    puts Messages.get_message(:manual)
  end

  def balance
    puts Messages.get_message(:balance, @balance)
  end

  def deposit
    until @value == -1 || @value.positive?
      puts Messages.get_message(:deposit_tip)
      @value = gets.to_f
    end
    return if @value == -1

    @balance += @value
    puts Messages.get_message(:deposited, @value)
    puts Messages.get_message(:balance, @balance)
  end

  def withdraw
    until @value == -1 || @value.between?(1, @balance)
      puts Messages.get_message(:withdraw_tip, @balance)
      @value = gets.to_f
    end
    return if @value == -1

    @balance -= @value
    puts Messages.get_message(:withdrawed, @value)
    puts Messages.get_message(:balance, @balance)
  end

  def quit
    File.write(@balance_file, @balance)
    @balance_file.close
  end

  alias_method 'h', :help
  alias_method 'b', :balance
  alias_method 'd', :deposit
  alias_method 'w', :withdraw
  alias_method 'q', :quit
end
