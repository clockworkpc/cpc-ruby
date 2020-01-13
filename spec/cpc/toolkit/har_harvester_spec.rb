require 'spec_helper'

RSpec.describe Cpc::Toolkit::HarHarvester do

  let(:har_path) { 'spec/fixtures/util/sample.har' }

  it 'should retrieve log values', offline: true do
    expect(subject.log(har_path).keys).to eq([:version, :creator, :pages, :entries])
  end
end
