# frozen_string_literal: true

# Allows client interact with his account
class ATM
  def initialize(balance_file_path)
    @default_balance = 1000
    @balance_file_path = if File.exist?(balance_file_path)
                           balance_file_path
                         else
                           File.open(balance_file_path) { |file| file.write(@default_balance) }
                         end
  end

  def balance
    File.read(@balance_file_path).chomp.to_f
  end

  def deposit(value)
    raise('Invalid input') unless value.to_f.positive?

    new_balance = balance.to_f + value.to_f
    File.write(@balance_file_path, new_balance)
    new_balance
  end

  def withdraw(value)
    raise 'Invalid input' unless value.to_f.between?(0, balance.to_f)

    new_balance = balance.to_f - value.to_f
    File.write(@balance_file_path, new_balance)
    new_balance
  end
end
