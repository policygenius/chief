module Chief
  class Command
    def self.new(*args, &block)
      obj = super
      internal_command = InternalCommand.new(obj)
      obj.send(:internal_command=, internal_command)
      internal_command
    end

    def self.call(*args, &block)
      new(*args, &block).call
    end

    def self.value(*args)
      call(*args).value
    end

    def call
      fail NotImplementedError, 'Implement #call in subclass'
    end

    def success!(value = true)
      internal_command.success!
      Result.new(value, nil)
    end

    def fail!(value = false, errors = true)
      internal_command.fail!
      Result.new(value, errors)
    end

    private

    attr_accessor :internal_command
  end

  class InternalCommand
    def initialize(obj)
      @obj = obj
      @fullfilled = false
    end

    def call
      result = obj.call
      if result.is_a?(Chief::Result) && fullfilled
        result
      else
        fail "#{obj.class}#call must call success! or fail! and return the result"
      end
    end

    def success!
      self.fullfilled = true
    end

    def fail!
      self.fullfilled = true
    end

    private

    attr_reader :obj
    attr_accessor :fullfilled
  end
  private_constant :InternalCommand
end
