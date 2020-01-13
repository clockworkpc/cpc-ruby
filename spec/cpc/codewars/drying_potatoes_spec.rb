require 'spec_helper'

RSpec.describe Cpc::Codewars::DryingPotatoes do
  include Cpc::Codewars::DryingPotatoes
#
  it 'should return the dried weight of 82kg', offline: true do
    expect(potatoes(82, 127, 80)).to eq(114)
  end

  it "should return the dried weight of 93kg", offline: true do
    expect(potatoes(93, 129, 91)).to eq(100)
  end
end
