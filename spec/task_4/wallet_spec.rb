# frozen_string_literal: true

require 'rspec'
require 'tempfile'
require_relative '../../src/task_4/wallet'

RSpec.describe 'wallet' do
  let(:file) { File.new(File.join(__dir__, 'balance.txt'), 'w+') }
  let(:file_dirname) { File.dirname(file.path) }
  let(:file_data) { '200' }

  before do
    File.write(file.path, file_data)
  end

  after(:example) do
    File.unlink(file.path)
  end

  describe 'help' do
    let(:expected_output) do
      [
        'Welcome to Wallet! To see help type - h.',
        'Enter action please >',
        'Please choose an action:',
        '  - H(h) - show manual',
        '  - B(b) - show balance',
        '  - D(d) - deposit money',
        '  - W(w) - withdraw money',
        '  - Q(q) - save balance and quit',
        'Enter action please >'
      ].join("\n") + "\n"
    end
    it '"h" - command shows help' do
      args = %w[h q]
      allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

      expect { wallet(file_dirname) }.to output(expected_output).to_stdout
    end
  end

  describe 'balance' do
    context '"b" - command display balance' do
      context 'when balance.txt exists' do
        let(:expected_output) do
          [
            'Welcome to Wallet! To see help type - h.',
            'Enter action please >',
            'Your balance is 200.0$',
            'Enter action please >'
          ].join("\n") + "\n"
        end
        it 'reads balance from balance.txt' do
          args = %w[b q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet(file_dirname) }.to output(expected_output).to_stdout
        end
      end
      context 'when balance.txt do not exists' do
        after { File.unlink('/tmp/balance.txt') }
        let(:expected_output) do
          [
            'Welcome to Wallet! To see help type - h.',
            'Enter action please >',
            'Your balance is 100.0$',
            'Enter action please >'
          ].join("\n") + "\n"
        end
        it 'reads balance from BALANCE constant' do
          args = %w[b q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet('/tmp') }.to output(expected_output).to_stdout
        end
      end
    end
  end

  describe 'deposit' do
    context '"d" - command deposit money to balance' do
      context 'when input "-1"' do
        let(:expected_output) do
          ['Welcome to Wallet! To see help type - h.',
           'Enter action please >',
           'Please enter value greater than 0 or type -1 for exit from transaction >',
           'Enter action please >'].join("\n") + "\n"
        end
        it 'aborts transaction execution' do
          args = %w[d -1 q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet(file_dirname) }.to output(expected_output).to_stdout
        end
      end
      context 'when input input invalid' do
        context 'input below 0' do
          let(:expected_output) do
            ['Welcome to Wallet! To see help type - h.',
             'Enter action please >',
             'Please enter value greater than 0 or type -1 for exit from transaction >',
             'Please enter value greater than 0 or type -1 for exit from transaction >',
             'Enter action please >'].join("\n") + "\n"
          end
          it 'request input again' do
            args = %w[d -10 -1 q]
            allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

            expect { wallet(file_dirname) }.to output(expected_output).to_stdout
          end
        end
      end
      context 'when input valid number' do
        let(:expected_output) do
          ['Welcome to Wallet! To see help type - h.',
           'Enter action please >',
           'Please enter value greater than 0 or type -1 for exit from transaction >',
           'Deposited 100.0$',
           'Your balance is 300.0$',
           'Enter action please >'].join("\n") + "\n"
        end
        it 'deposits money to balance' do
          args = %w[d 100 q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet(file_dirname) }.to output(expected_output).to_stdout
        end
      end
    end
  end

  describe 'withdraw' do
    context '"w" - command withdraw money from balance' do
      context 'when input "-1"' do
        let(:expected_output) do
          ['Welcome to Wallet! To see help type - h.',
           'Enter action please >',
           'Please enter value between 0 and 200.0.',
           'Or enter -1 for exit from transaction >',
           'Enter action please >'].join("\n") + "\n"
        end
        it 'aborts transaction execution' do
          args = %w[w -1 q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet(file_dirname) }.to output(expected_output).to_stdout
        end
      end
      context 'when input invalid' do
        context 'input below 0' do
          let(:expected_output) do
            ['Welcome to Wallet! To see help type - h.',
             'Enter action please >',
             'Please enter value between 0 and 200.0.',
             'Or enter -1 for exit from transaction >',
             'Please enter value between 0 and 200.0.',
             'Or enter -1 for exit from transaction >',
             'Enter action please >'].join("\n") + "\n"
          end
          it 'request input again' do
            args = %w[w -10 -1 q]
            allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

            expect { wallet(file_dirname) }.to output(expected_output).to_stdout
          end
        end
        context 'input greater than balance' do
          let(:expected_output) do
            ['Welcome to Wallet! To see help type - h.',
             'Enter action please >',
             'Please enter value between 0 and 200.0.',
             'Or enter -1 for exit from transaction >',
             'Please enter value between 0 and 200.0.',
             'Or enter -1 for exit from transaction >',
             'Enter action please >'].join("\n") + "\n"
          end
          it 'request input again' do
            args = %w[w 300 -1 q]
            allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

            expect { wallet(file_dirname) }.to output(expected_output).to_stdout
          end
        end
      end
      context 'when input valid number' do
        let(:expected_output) do
          ['Welcome to Wallet! To see help type - h.',
           'Enter action please >',
           'Please enter value between 0 and 200.0.',
           'Or enter -1 for exit from transaction >',
           'Withdrawed 100.0$',
           'Your balance is 100.0$',
           'Enter action please >'].join("\n") + "\n"
        end
        it 'withdraw money from balance' do
          args = %w[w 100 q]
          allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

          expect { wallet(file_dirname) }.to output(expected_output).to_stdout
        end
      end
    end
  end

  describe 'quit' do
    context '"q" - command exits from programm' do
      let(:expected_balance) { '100.0' }
      let(:expected_output) do
        ['Welcome to Wallet! To see help type - h.',
         'Enter action please >',
         'Please enter value between 0 and 200.0.',
         'Or enter -1 for exit from transaction >',
         'Withdrawed 100.0$',
         'Your balance is 100.0$',
         'Enter action please >'].join("\n") + "\n"
      end
      it 'saves balance and exits' do
        args = %w[w 100 q]
        allow_any_instance_of(Kernel).to receive(:gets).and_return(*args)

        expect { wallet(file_dirname) }.to output(expected_output).to_stdout
        expect(File.read(File.join(file_dirname, 'balance.txt'))).to eq(expected_balance)
      end
    end
  end
end
