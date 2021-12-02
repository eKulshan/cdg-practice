# frozen_string_literal: true

require 'rspec'
require_relative '../../src/task_3/word_square'

RSpec.describe 'word_square' do
  test_data = [
    {
      name: 'word ends with "CS"',
      input: 'wordCS',
      expected: 64
    },
    {
      name: 'word not ends with "CS"',
      input: 'word',
      expected: 'drow'
    }
  ]

  test_data.each do |test_case_data|
    name, input, expected = test_case_data.values_at(:name, :input, :expected)
    it name do
      expect(word_square(input)).to eq(expected)
    end
  end
end
