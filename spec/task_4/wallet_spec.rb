# frozen_string_literal: true

require 'rspec'
require 'tempfile'
require_relative '../../src/task_4/wallet'

RSpec.describe 'wallet' do
  let(:file) { File.new(File.join(__dir__, 'balance.txt'), 'w+') }
  let(:file_dirname) { File.dirname(file.path) }
  let(:file_data) { '200' }
  let(:args) { [] }
  before do
    File.write(file.path, file_data)
  end

  after(:suite) do
    File.unlink(file.path)
  end

  describe 'balance' do
    context '"b" - command display balance' do
      context 'when balance.txt exists' do
        let(:expected) do
          [
            'Welcome to Wallet! To see help type - h.',
            'Enter action please > ',
            'Your balance is 200.0$',
            'Enter action please > '
          ].join("\n") + "\n"
        end
        it 'reads balance from balance.txt' do
          args = %w[b q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet(file_dirname) }.to output(expected).to_stdout
        end
      end
      context 'when balance.txt do not exists' do
        after { File.unlink('/tmp/balance.txt') }
        let(:expected) do
          [
            'Welcome to Wallet! To see help type - h.',
            'Enter action please > ',
            'Your balance is 100.0$',
            'Enter action please > '
          ].join("\n") + "\n"
        end
        it 'reads balance from BALANCE constant' do
          args = %w[b q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet('/tmp') }.to output(expected).to_stdout
        end
      end
    end
  end

  describe 'help' do
    let(:expected) do
      [
        'Welcome to Wallet! To see help type - h.',
        'Enter action please > ',
        'Please choose an action:',
        '  - H(h) - show manual',
        '  - B(b) - show balance',
        '  - D(d) - deposit money',
        '  - W(w) - withdraw money',
        '  - Q(q) - save balance and quit',
        'Enter action please > '
      ].join("\n") + "\n"
    end
    it '"h" - command shows help' do
      args = %w[h q]
      allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

      expect { wallet(file_dirname) }.to output(expected).to_stdout
    end
  end
end
