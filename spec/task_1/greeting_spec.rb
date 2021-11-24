# frozen_string_literal: true

require 'rspec'
require_relative '../../task_1/greeting'

RSpec.describe 'greeting' do
  test_data = [
    {
      name: 'young test',
      input: %w[John Snow 17],
      expected: 'Hello, John Snow! You are younger than 18 but learning programming is never too early.'
    },
    {
      name: 'adult test',
      input: %w[John Snow 25],
      expected: 'Hello, John Snow! Let\'s get down to business!'
    }
  ]

  test_data.each do |test_case_data|
    name, input, expected = test_case_data.values_at(:name, :input, :expected)
    it name do
      allow_any_instance_of(Kernel).to receive(:gets).and_return(*input)

      expect(greeting).to eq(expected)
    end
  end
end
