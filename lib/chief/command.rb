module Chief
  class Command
    def self.call(*args, &block)
      new(*args, &block).call
    end

    def self.value(*args, &block)
      call(*args, &block).value
    end

    def self.inherited(subclass)
      subclass.send(:prepend, Module.new do
        def call
          obj = self
          result = super
          if result.is_a?(Chief::Result) && obj.send(:fullfilled)
            result
          else
            fail "#{obj.class}#call must call success! or fail! and return the result"
          end
        end

        def success!(value = true)
          create_result_object(value, nil)
        end

        def fail!(value = false, errors = true)
          create_result_object(value, errors)
        end

        private

        def create_result_object(value, errors)
          @fullfilled = true
          Result.new(value, errors)
        end

        attr_accessor :fullfilled
      end)
    end
  end
end
