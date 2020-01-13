require 'spec_helper'

RSpec.describe Cpc::Codewars::Order do
  include Cpc::Codewars::Order

  let(:input_str1) { 'is2 Thi1s T4est 3a' }
  let(:input_str2) { '4of Fo1r pe6ople g3ood th5e the2' }
  let(:input_str3) { '' }

  let(:output_str1) { 'Thi1s is2 3a T4est' }
  let(:output_str2) { 'Fo1r the2 g3ood 4of th5e pe6ople' }
  let(:output_str3) { '' }

  let(:word1) { 'Thi1s' }
  let(:word2) { 'is2' }
  let(:word3) { '3a' }

  context 'Examples from Codewars', offline: true do
    it "should return the word's number" do
      expect(word_number(word1)).to eq(1)
      expect(word_number(word2)).to eq(2)
      expect(word_number(word3)).to eq(3)
    end

    it "should return 'is this a test'" do
      expect(order(input_str1)).to eq(output_str1)
    end

    it "should return 'for the good of the people'" do
      expect(order(input_str2)).to eq(output_str2)
    end

    it "should return ''" do
      expect(order('')).to eq('')
    end
  end
end
