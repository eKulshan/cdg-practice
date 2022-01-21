# frozen_string_literal: true

require 'rspec'
require 'tempfile'
require_relative '../../src/task_4/move_user'

RSpec.describe 'move_users' do
  users_file = Tempfile.create('users')
  result_file = Tempfile.create('result')
  users_data = [
    'Karlene Stamm 37',
    'Gus Powlowski 15',
    'Shemika Muller 33',
    'Somer Schultz 42',
    'Jonas Kris 33'
  ].join("\n")

  before(:each) do
    File.write(users_file.path, users_data)
    File.write(result_file.path, '')
  end

  after(:all) do
    File.unlink(users_file.path)
    File.unlink(result_file.path)
  end

  test_data = [
    {
      name: 'moved all',
      input: {
        source: users_file.path,
        destination: result_file.path,
        args: %w[37 15 33 1 42 33]
      },
      expected: {
        file_content: [
          'Karlene Stamm 37',
          'Gus Powlowski 15',
          'Shemika Muller 33',
          'Somer Schultz 42',
          'Jonas Kris 33'
        ],
        console_output: [
          '==> Type "a" to see all users or "q" to exit.',
          '==> Please enter user age >',
          '==> Please enter user age >',
          '==> Please enter user age >',
          '==> Matched users (2) <==',
          'Shemika Muller 33',
          'Jonas Kris 33',
          '==> Please choose which user to move. Enter user number >',
          '==> Please enter user age >',
          '==> Please enter user age >',
          '==> Moved users (5) <==',
          'Karlene Stamm 37',
          'Gus Powlowski 15',
          'Shemika Muller 33',
          'Somer Schultz 42',
          'Jonas Kris 33'
        ]
      }
    },
    {
      name: 'moved partial',
      input: {
        source: users_file.path,
        destination: result_file.path,
        args: %w[37 15 q]
      },
      expected: {
        file_content: [
          'Karlene Stamm 37',
          'Gus Powlowski 15'
        ],
        console_output: [
          '==> Type "a" to see all users or "q" to exit.',
          '==> Please enter user age >',
          '==> Please enter user age >',
          '==> Please enter user age >',
          '==> Moved users (2) <==',
          'Karlene Stamm 37',
          'Gus Powlowski 15'
        ]
      }
    },
    {
      name: 'moved none',
      input: {
        source: users_file.path,
        destination: result_file.path,
        args: %w[q]
      },
      expected: {
        file_content: [],
        console_output: [
          '==> Type "a" to see all users or "q" to exit.',
          '==> Please enter user age >',
          '==> Moved users (0) <=='
        ]
      }
    }
  ]

  test_data.each do |test_case_data|
    name, input, expected = test_case_data.values_at(:name, :input, :expected)
    source, destination, args = input.values_at(:source, :destination, :args)
    file_content, console_output = expected.values_at(:file_content, :console_output)

    it name do
      get_message(:actions_tip)
      allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)
      stdout = capture_stdout { move_users(source, destination) }

      expect(File.read(destination).split("\n")).to eq(file_content)
      expect(stdout).to eq(console_output)
    end
  end
end
