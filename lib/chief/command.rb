module Chief
  class Command
    def self.call(*args)
      new(*args).call
    end

    def self.value(*args)
      call(*args).value
    end

    def call
      fail NotImplementedError, 'Implement #call in subclass'
    end

    def success!(value = true)
      Result.new(value, nil)
    end

    def fail!(value = false, errors = true)
      Result.new(value, errors)
    end
  end
end
