# frozen_string_literal: true

require 'rspec'
require 'tempfile'
require_relative '../../src/task_4/file_controller'

RSpec.describe 'file_controller' do
  file = Tempfile.create('text')
  file_data = %w[apple orange banana pineapple cherry].join("\n")

  before(:each) do
    File.write(file.path, file_data)
  end

  after(:all) do
    File.unlink(file.path)
  end

  test_data = [
    {
      name: 'index',
      input: { filepath: file.path, method: 'index', args: [] },
      expected: %w[apple orange banana pineapple cherry]
    },
    {
      name: 'find',
      input: { filepath: file.path, method: 'find', args: [3] },
      expected: 'banana'
    },
    {
      name: 'where',
      input: { filepath: file.path, method: 'where', args: ['app'] },
      expected: %w[apple pineapple]
    },
    {
      name: 'update',
      input: { filepath: file.path, method: 'update', args: [1, 'mango'] },
      expected: %w[mango orange banana pineapple cherry]
    },
    {
      name: 'delete',
      input: { filepath: file.path, method: 'delete', args: [3] },
      expected: %w[apple orange pineapple cherry]
    }
  ]

  test_data.each do |test_case_data|
    name, input, expected = test_case_data.values_at(:name, :input, :expected)
    filepath, method, args = input.values_at(:filepath, :method, :args)
    it name do
      expect(
        FileController.new(filepath).method(method.to_sym)[*args]
      ).to eq(expected)
    end
  end
end

RSpec.describe FileController do
  let(:file) { Tempfile.create('text') }
  let(:file_data) { %w[apple orange banana pineapple cherry].join("\n") }

  before(:each) do
    File.write(file.path, file_data)
  end

  after(:suite) do
    File.unlink(file.path)
  end

  subject { FileController.new(file.path) }

  describe '#index' do
    let(:expected) { %w[apple orange banana pineapple cherry] }

    it 'renders file content' do
      expect(subject.index).to eq(expected)
    end
  end

  describe '#find' do
    let(:expected) { 'banana' }
    let(:row_number) { 3 }

    it 'finds and returns row bu number' do
      expect(subject.find(row_number)).to eq(expected)
    end
  end

  describe '#where' do
    let(:expected) { %w[apple pineapple] }
    let(:pattern) { 'app' }

    it 'finds and returns all rows with a given pattern' do
      expect(subject.where(pattern)).to eq(expected)
    end
  end

  describe '#update' do
    let(:expected) { %w[mango orange banana pineapple cherry] }
    let(:row_number) { 1 }
    let(:new_string) { 'mango' }

    it 'updates row by number with given data' do
      expect(subject.update(row_number, new_string)).to eq(expected)
    end
  end

  describe '#delete' do
    let(:expected) { %w[apple orange pineapple cherry] }
    let(:row_number) { 3 }

    it 'deletes row by given number' do
      expect(subject.delete(row_number)).to eq(expected)
    end
  end
end
