# frozen_string_literal: true

require 'rspec'
require_relative '../../task_2/foobar'

RSpec.describe 'foobar' do
  test_data = [
    {
      name: 'first num is 20',
      input: [20, 13],
      expected: 13
    },
    {
      name: 'second num is 20',
      input: [13, 20],
      expected: 20
    },
    {
      name: 'none of nums is 20',
      input: [13, 17],
      expected: 30
    }
  ]

  test_data.each do |test_case_data|
    name, input, expected = test_case_data.values_at(:name, :input, :expected)
    it name do
      allow_any_instance_of(Kernel).to receive(:gets).and_return(*input)

      expect(foobar).to eq(expected)
    end
  end
end
