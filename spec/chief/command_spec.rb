require 'spec_helper'

module Example
  class SuccessfulCommand < Chief::Command
    attr_reader :example_param

    def initialize(example_param)
      @example_param = example_param
    end

    def call
      success!(example_param)
    end
  end

  class FailingCommand < Chief::Command
    attr_reader :example_param

    def initialize(example_param)
      @example_param = example_param
    end

    def call
      fail!(:some_value, :some_errors_object)
    end
  end

  class CommandWithoutChiefResult < Chief::Command
    def call
      :some_value
    end
  end

  class CommandWithChiefResultPassThrough < Chief::Command
    def call
      FailingCommand.call(:some_value)
    end
  end

  class InitializedWithBlockCommand < Chief::Command
    attr_accessor :result

    def initialize
      yield self
    end

    def call
      success! result
    end
  end
end

describe Chief::Command do
  describe "Commands that don't return a Chief::Result object" do
    it 'should raise an error' do
      expect { Example::CommandWithoutChiefResult.call }.to raise_error(RuntimeError)
    end
  end

  describe 'Commands that pass through a different commands Chief::Result object' do
    it 'should raise an error' do
      expect { Example::CommandWithChiefResultPassThrough.call }.to raise_error(RuntimeError, /Example::CommandWithChiefResultPassThrough/)
    end
  end

  describe "Commands that are instantiated with new and don't return a Chief::Result object" do
    it 'should raise an error' do
      expect { Example::CommandWithoutChiefResult.new.call }.to raise_error(RuntimeError)
    end
  end

  describe "Commands that are instantiated with new and don't pass through a different commands Chief::Result object" do
    it 'should raise an error' do
      expect { Example::CommandWithChiefResultPassThrough.new.call }.to raise_error(RuntimeError, /Example::CommandWithChiefResultPassThrough/)
    end
  end

  describe 'Commands that execute successfully' do
    it 'returns a success result object' do
      result = Example::SuccessfulCommand.call(:some_value)

      expect(result).to be_a Chief::Result
      expect(result).to be_success
      expect(result.value).to eq :some_value
    end

    it 'allows the result to be easily destructured' do
      result, value, errors = Example::SuccessfulCommand.call(:some_value)

      expect(result).to be_a Chief::Result
      expect(result).to be_success
      expect(value).to eq :some_value
      expect(errors).to be_nil
    end
  end

  describe 'Commands that fail' do
    it 'returns a failed result object' do
      result = Example::FailingCommand.call(:some_value)

      expect(result).to be_a Chief::Result
      expect(result).to be_failure
      expect(result.value).to eq :some_value
    end

    it 'allows the result to be easily destructured' do
      result, value, errors = Example::FailingCommand.call(:some_value)

      expect(result).to be_a Chief::Result
      expect(result).to be_failure
      expect(value).to eq :some_value
      expect(errors).to eq :some_errors_object
    end
  end

  describe 'Commands when given blocks' do
    it 'should correctly evaluate the block' do
      result = Example::InitializedWithBlockCommand.new do |c|
        c.result = 'foo'
      end.call

      expect(result).to be_a Chief::Result
      expect(result).to be_success
      expect(result.value).to eq 'foo'
    end
  end
end
