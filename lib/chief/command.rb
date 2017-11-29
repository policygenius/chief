module Chief
  class Command
    def self.call(*args, &block)
      instance = new(*args, &block)
      result = instance.call
      if result.is_a?(Chief::Result) && instance.send(:created_result_object)
        result
      else
        fail "#{method(__method__).receiver} must call success! or fail! and return the result"
      end
    end

    def self.value(*args)
      call(*args).value
    end

    def call
      fail NotImplementedError, 'Implement #call in subclass'
    end

    def success!(value = true)
      create_result_object(value, nil)
    end

    def fail!(value = false, errors = true)
      create_result_object(value, errors)
    end

    private

    attr_reader :created_result_object

    def create_result_object(value, errors)
      @created_result_object = true
      Result.new(value, errors)
    end
  end
end
