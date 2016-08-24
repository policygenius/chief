require 'spec_helper'

RSpec.describe Chief do
  it 'has a version number' do
    expect(Chief::VERSION).not_to be nil
  end
end
