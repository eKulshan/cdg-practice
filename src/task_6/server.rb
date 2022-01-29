# frozen_string_literal: true

require 'socket'
require 'rack'
require 'rack/utils'
require_relative 'ATM'

# server = TCPServer.new('0.0.0.0', 3000)

# Serving ATM interface for client
class App
  def initialize(balance_file_path)
    @atm = ATM.new(balance_file_path)
    @views = {
      help: -> { File.read(File.join(__dir__, 'views/help.html')).split("\n") },
      balance: -> { File.read(File.join(__dir__, 'views/balance.html')).gsub('$balance$', @atm.balance.to_s).split("\n") },
      deposit: -> { File.read(File.join(__dir__, 'views/deposit.html')).split("\n") },
      withdraw: -> { File.read(File.join(__dir__, 'views/withdraw.html')).gsub('$balance$', @atm.balance.to_s).split("\n") }
    }
  end

  def help
    status  = 200
    headers = { 'Content-Type' => 'text/html' }
    body    = @views[:help].call

    [status, headers, body]
  end

  def balance
    status  = 200
    headers = { 'Content-Type' => 'text/html' }
    body    = @views[:balance].call

    [status, headers, body]
  end

  def deposit_input
    status  = 200
    headers = { 'Content-Type' => 'text/html' }
    body    = @views[:deposit].call

    [status, headers, body]
  end

  def deposit(params)
    @atm.deposit(params['value'])
    status  = 302
    headers = { 'Content-Type' => 'text/html', 'Location' => '/balance' }
    body    = []

    [status, headers, body]
  end

  def withdraw_input
    status  = 200
    headers = { 'Content-Type' => 'text/html' }
    body    = @views[:withdraw].call

    [status, headers, body]
  end

  def withdraw(params)
    @atm.withdraw(params['value'])
    status  = 302
    headers = { 'Content-Type' => 'text/html', 'Location' => '/balance' }
    body    = []

    [status, headers, body]
  end

  def not_found
    status  = 404
    headers = { 'Content-Type' => 'text/html' }
    body    = ['Not found']

    [status, headers, body]
  end

  def call(env)
    req = Rack::Request.new(env)
    params = req.POST

    case req.path
    when '/'
      help
    when '/balance'
      balance
    when '/deposit'
      return deposit_input unless req.post?

      deposit(params)
    when '/withdraw'
      return withdraw_input unless req.post?

      withdraw(params)
    else
      not_found
    end
  end
end
