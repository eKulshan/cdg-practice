# frozen_string_literal: true

require 'rspec'
require_relative '../../src/task_6/ATM'

RSpec.describe ATM do
  let(:balance_file) { File.new(File.join(__dir__, 'balance.txt'), 'w+') }
  let(:start_balance) { '1000.0' }

  subject { ATM.new(balance_file.path) }

  before do
    File.write(balance_file.path, start_balance)
  end

  after(:example) do
    File.delete(balance_file.path)
  end

  describe '#balance' do
    context 'show current balance' do
      it 'should be equal start balance' do
        expect(subject.balance).to eq(start_balance.to_f)
      end
    end
  end

  describe '#deposit' do
    context 'when input value is valid' do
      let(:value) { '200' }
      let(:expected_balance) { start_balance.to_f + value.to_f }
      it 'adds value to balance' do
        subject.deposit(value)
        expect(subject.balance).to eq(expected_balance)
      end
    end
    context 'when input value is not valid' do
      let(:wrong_value) { '-10' }
      it 'raise "invalid input" error' do
        expect { subject.deposit(wrong_value) }.to raise_error(RuntimeError, 'Invalid input')
      end
    end
  end

  describe '#withdraw' do
    context 'when input value is valid' do
      let(:value) { '200' }
      let(:expected_balance) { start_balance.to_f - value.to_f }
      it 'substracts value from balance' do
        subject.withdraw(value)
        expect(subject.balance).to eq(expected_balance)
      end
    end
    context 'when input value is not valid' do
      let(:wrong_value) { '10000' }
      it 'raise "invalid input" error' do
        expect { subject.withdraw(wrong_value) }.to raise_error(RuntimeError, 'Invalid input')
      end
    end
  end
end
