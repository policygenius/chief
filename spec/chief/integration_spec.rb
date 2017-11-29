require 'spec_helper'

module Chief
  class ExampleSuccessfulCommand < Command
    attr_reader :example_param

    def initialize(example_param)
      @example_param = example_param
    end

    def call
      success!(example_param)
    end
  end

  class ExampleFailingCommand < Command
    attr_reader :example_param

    def initialize(example_param)
      @example_param = example_param
    end

    def call
      fail!(:some_value, :some_errors_object)
    end
  end

  class ExampleWithoutChiefResultCommand < Command
    def call
      :some_value
    end
  end

  class ExampleWithChiefResultPassThroughCommand < Command
    def call
      ExampleFailingCommand.call(:some_value)
    end
  end

  RSpec.describe Command do
    describe "Commands that don't return a Chief::Result object" do
      it 'should raise an error' do
        expect { ExampleWithoutChiefResultCommand.call }.to raise_error(RuntimeError)
      end
    end

    describe 'Commands that pass through a different commands Chief::Result object' do
      it 'should raise an error' do
        expect { ExampleWithChiefResultPassThroughCommand.call }.to raise_error(RuntimeError, /ExampleWithChiefResultPassThroughCommand/)
      end
    end

    describe 'Commands that execute successfully' do
      it 'returns a success result object' do
        result = ExampleSuccessfulCommand.call(:some_value)

        expect(result).to be_a Result
        expect(result).to be_success
        expect(result.value).to eq :some_value
      end

      it 'allows the result to be easily destructured' do
        result, value, errors = ExampleSuccessfulCommand.call(:some_value)

        expect(result).to be_a Result
        expect(result).to be_success
        expect(value).to eq :some_value
        expect(errors).to be_nil
      end
    end

    describe 'Commands that fail' do
      it 'returns a failed result object' do
        result = ExampleFailingCommand.call(:some_value)

        expect(result).to be_a Result
        expect(result).to be_failure
        expect(result.value).to eq :some_value
      end

      it 'allows the result to be easily destructured' do
        result, value, errors = ExampleFailingCommand.call(:some_value)

        expect(result).to be_a Result
        expect(result).to be_failure
        expect(value).to eq :some_value
        expect(errors).to eq :some_errors_object
      end
    end
  end
end
