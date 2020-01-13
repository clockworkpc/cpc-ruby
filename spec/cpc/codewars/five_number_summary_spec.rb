require 'spec_helper'

RSpec.describe Cpc::Codewars::FiveNumberSummary do
  include Cpc::Codewars::FiveNumberSummary

  let(:odd_count_ary_0) { [1,1,2,3,5,8,13,21,34] }
  let(:odd_count_ary_1) { [1,1,2,3,5,8,13,21,34,55,89] }
  let(:odd_count_ary_2) { [1,1,2,3,5,8,13,21,34,55,89,144,233] }
  let(:odd_count_ary_3) { [1,1,2,3,5,8,13,21,34,55,89,144,233] }

  let(:even_count_ary_0) { [1,1,2,3,5,8,13,21] }
  let(:even_count_ary_1) { [1,1,2,3,5,8,13,21,34,55] }
  let(:even_count_ary_2) { [1,1,2,3,5,8,13,21,34,55,89,144] }

  let(:input_ary_0) { [5,4,6,-8,-2,-1,-8,7] }
  let(:output_ary_0) { [-8.0,-5.0,1.5,5.5,7.0] }
  let(:input_ary_1) { [4, 6, -6, 7, -3] }
  let(:output_ary_1) { [-6, -3, 4, 6, 7] }

  it 'should return a median Integer from an Array with an odd count', offline: true do
    expect(median_value(odd_count_ary_0)).to eq(5)
    expect(median_value(odd_count_ary_1)).to eq(8)
    expect(median_value(odd_count_ary_2)).to eq(13)
  end

  it 'should return a pair of Integers in an Array from an Array with an even count', offline: true do
    expect(median_value(even_count_ary_0)).to eq(4)
    expect(median_value(even_count_ary_1)).to eq(6.5)
    expect(median_value(even_count_ary_2)).to eq(10.5)
  end

  it 'should return ordered numbers', offline: true do
    expect(five_num(input_ary_0)).to eq(output_ary_0)
    # expect(five_num(input_ary_1)).to eq(output_ary_1)
  end


end
