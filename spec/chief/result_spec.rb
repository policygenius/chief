require 'spec_helper'

module Chief
  RSpec.describe Result do
    describe '#failure?' do
      let(:some_value) { double(:some_value) }

      context 'when the Result has errors' do
        let(:some_errors) { double(:some_errors) }

        it 'returns true' do
          result = Result.new(some_value, some_errors)
          expect(result.failure?).to be_truthy
        end
      end

      context 'when the Result does not have errors' do
        let(:some_errors) { nil }

        it 'returns false' do
          result = Result.new(some_value, some_errors)
          expect(result.failure?).to be_falsey
        end
      end
    end

    describe '#success?' do
      let(:some_value) { double(:some_value) }

      context 'when the Result has errors' do
        let(:some_errors) { double(:some_errors) }

        it 'returns false' do
          result = Result.new(some_value, some_errors)
          expect(result.success?).to be_falsey
        end
      end

      context 'when the Result does not have errors' do
        let(:some_errors) { nil }

        it 'returns true' do
          result = Result.new(some_value, some_errors)
          expect(result.success?).to be_truthy
        end
      end

      context 'when the Result is not given an error' do
        it 'returns true' do
          result = Result.new(some_value)
          expect(result.success?).to be_truthy
        end
      end
    end

    describe '#successful?' do
      let(:some_value) { double(:some_value) }

      context 'when the Result has errors' do
        let(:some_errors) { double(:some_errors) }

        it 'returns false' do
          result = Result.new(some_value, some_errors)
          expect(result.successful?).to be_falsey
        end
      end

      context 'when the Result does not have errors' do
        let(:some_errors) { nil }

        it 'returns true' do
          result = Result.new(some_value, some_errors)
          expect(result.successful?).to be_truthy
        end
      end

      context 'when the Result is not given an error' do
        it 'returns true' do
          result = Result.new(some_value)
          expect(result.successful?).to be_truthy
        end
      end
    end

    describe '#value' do
      let(:some_value) { double(:some_value) }
      let(:some_errors) { double(:some_errors) }

      it 'returns the value of the result' do
        expect(Result.new(some_value, some_errors).value).to eq some_value
      end
    end

    describe '#to_ary' do
      let(:some_value) { double(:some_value) }
      let(:some_errors) { double(:some_errors) }

      it 'supports Array destructuring' do
        failed_result = Result.new(some_value, some_errors)

        result, value, errors = failed_result

        expect(result).to eq failed_result
        expect(value).to eq some_value
        expect(errors).to eq some_errors
      end
    end
  end
end
