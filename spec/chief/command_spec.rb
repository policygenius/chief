require 'spec_helper'

module Chief
  RSpec.describe Command do
    describe '#success!' do
      subject(:command) { Command.new }
      let(:successful_result) { double(:successful_result) }

      context 'when it is called without specifying a value' do
        before do
          allow(Result)
            .to receive(:new)
            .with(true, nil)
            .and_return(successful_result)
        end

        it 'returns a Result with a default value of true' do
          expect(command.success!).to eq successful_result
        end
      end

      context 'when it is called with a value' do
        let(:example_value) { double(:example_value) }

        before do
          allow(Result)
            .to receive(:new)
            .with(example_value, nil)
            .and_return(successful_result)
        end

        it 'returns a Result with the specified value' do
          expect(command.success!(example_value)).to be successful_result
        end
      end
    end

    describe '.fail!' do
      subject(:command) { Command.new }
      let(:failed_result) { double(:failed_result) }

      context 'when it is called without specifying the value nor the errors' do
        before do
          allow(Result)
            .to receive(:new)
            .with(false, true)
            .and_return(failed_result)
        end

        it 'returns a Result with a false value with errors set to true' do
          expect(command.fail!).to be failed_result
        end
      end

      context 'when it is called with a value but without specifying the errors' do
        let(:example_value) { double(:example_value) }

        before do
          allow(Result)
            .to receive(:new)
            .with(example_value, true)
            .and_return(failed_result)
        end

        it 'returns a Result with a false value with errors set to true' do
          expect(command.fail!(example_value)).to be failed_result
        end
      end

      context 'when it is called with a value and an errors object' do
        let(:example_value) { double(:example_value) }
        let(:example_errors) { double(:example_errors) }

        before do
          allow(Result)
            .to receive(:new)
            .with(example_value, example_errors)
            .and_return(failed_result)
        end

        it 'returns a Result with the specified value and errors' do
          expect(command.fail!(example_value, example_errors)).to be failed_result
        end
      end
    end
  end
end
