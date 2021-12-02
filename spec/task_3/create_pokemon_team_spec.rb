# frozen_string_literal: true

require 'rspec'
require_relative '../../src/task_3/create_pokemon_team'

RSpec.describe 'create_pokemon_team' do
  test_data = [
    {
      name: 'team size is 0',
      input: '0',
      expected: []
    },
    {
      name: 'team size is 3 ',
      input: ['3', 'fluffy pink', 'pikachu yellow', 'blue blue'],
      expected: [
        { name: 'fluffy', color: 'pink' },
        { name: 'pikachu', color: 'yellow' },
        { name: 'blue', color: 'blue' }
      ]
    }
  ]

  test_data.each do |test_case_data|
    name, input, expected = test_case_data.values_at(:name, :input, :expected)
    it name do
      allow_any_instance_of(Kernel).to receive(:gets).and_return(*input)

      expect(create_pokemon_team).to eq(expected)
    end
  end
end
