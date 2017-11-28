module Chief
  class Result
    attr_reader :value, :errors

    def initialize(value, errors = nil)
      @value = value
      @errors = errors
    end

    def success?
      errors.nil?
    end

    def failure?
      !success?
    end

    def to_ary
      [self, value, errors]
    end
  end
end
