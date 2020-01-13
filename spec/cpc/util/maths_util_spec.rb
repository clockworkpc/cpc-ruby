require 'spec_helper'

RSpec.describe Cpc::Util::MathsUtil do
  include Cpc::Util::MathsUtil
  let(:claim_amount_ary) {[0.000000, 11.000000, 44.000000, 1625.250000, 2579.500000, 3244.999981, 3978.692300, 7957.384500, 11000.000000, 11789.769200, 15914.769200, 21734.891200, 155902.691000, ]}

context 'offline', offline: true do
  it "should return 100% between 10 and 0" do
    expect(number_diff(10, 0)).to eq(1)
  end

  it "should return 50% between 10 and 5" do
    expect(number_diff(10,5)).to eq(0.5)
  end

  it "should return more than 5%" do
    expect(number_diff(15914.769200, 11789.769200).round(2)).to eq(0.26)
    expect(number_diff(3978.692300, 1625.250000).round(2)).to eq(0.59)
  end

  # it "should return all numbers" do
  #   diff_ary = []
  #
  #   claim_amount_ary.each do |n0|
  #     claim_amount_ary.each do |n1|
  #       puts "#{n0}, #{n1}, #{number_diff(n0, n1).round(2)}"
  #       diff_ary << number_diff(n0, n1)
  #     end
  #   end
  # end

end

end
