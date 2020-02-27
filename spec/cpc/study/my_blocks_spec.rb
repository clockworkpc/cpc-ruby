require 'spec_helper'

RSpec.describe Cpc::Study::MyBlocks do
  context "with yield", offline: true do
    it 'should return the return value of a block' do
      expect(subject.method_with_yield {"hello world"}).to eq("hello world")
    end
  end

  context "sans yield", offline: true do
    it 'should not return the return value of a block' do
      expect(subject.method_sans_yield {"hello world"}).to eq(nil)
    end
  end
end
