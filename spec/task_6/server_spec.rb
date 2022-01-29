# frozen_string_literal: true

require 'rspec'
require_relative '../../src/task_6/server'

describe App do
  let(:balance_file) { File.new(File.join(__dir__, 'balance.txt'), 'w+') }
  let(:start_balance) { '1000.0' }
  let(:app) { App.new(balance_file.path) }

  after(:example) do
    File.delete(balance_file.path)
  end

  describe '/' do
    before { File.write(balance_file.path, start_balance) }

    context 'GET' do
      let(:response) { get '/' }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end
      it 'displays a list of available actions' do
        expect(response.body).to include('Available actions:')
      end
    end
  end

  describe '/balance' do
    before { File.write(balance_file.path, start_balance) }

    context 'GET' do
      let(:response) { get '/balance' }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end
      it 'displays balance' do
        expect(response.body).to match(/Your balance is \d*/)
      end
    end
  end

  describe '/deposit' do
    before { File.write(balance_file.path, start_balance) }

    context 'GET' do
      let(:response) { get '/deposit' }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end
      it 'displays form for input value to deposit' do
        expect(response.body).to include('<form method="post" name="deposit_input">')
      end
    end

    context 'POST' do
      let(:value) { '100' }
      let(:response) { post '/deposit', value: value }
      let(:expected_balance) { start_balance.to_f + value.to_f }

      it 'returns status 302' do
        expect(response.status).to eq 302
      end
      it 'redirects to /balance' do
        expect(response.headers['Location']).to eq('/balance')
      end
      it 'increases balance by input value' do
        post '/deposit', value: value # TODO: costyl removal
        actual_balance = File.read(balance_file.path).chomp.to_f

        expect(actual_balance).to eq(expected_balance)
      end
    end
  end

  describe '/withdraw' do
    before { File.write(balance_file.path, start_balance) }

    context 'GET' do
      let(:response) { get '/withdraw' }

      it 'returns status 200' do
        expect(response.status).to eq 200
      end
      it 'displays form to input value to withdraw' do
        expect(response.body).to include('<form method="post" name="withdraw_input">')
      end
    end

    context 'POST' do
      let(:value) { '100' }
      let(:response) { post '/withdraw', value: value }
      let(:expected_balance) { start_balance.to_f - value.to_f }

      it 'returns status 302' do
        expect(response.status).to eq 302
      end
      it 'redirects to /balance' do
        expect(response.headers['Location']).to eq('/balance')
      end
      it 'discreases balance by input value' do
        post '/withdraw', value: value # TODO: costyl removal
        actual_balance = File.read(balance_file.path).chomp.to_f

        expect(actual_balance).to eq(expected_balance)
      end
    end
  end

  describe '/wrongpath' do
    context 'GET' do
      let(:response) { get '/wrongpath' }

      it 'returns status 404' do
        expect(response.status).to eq 404
      end
      it 'shows message' do
        expect(response.body).to include('Not found')
      end
    end
  end
end
