require 'spec_helper'

RSpec.describe Cpc::Study::Spaceship do

  let(:my_attrs) { {destination: "Earth", weight: 10} }

  context "Basic", offline: true do
    it 'return attrs' do
      expect(subject.locate_cargo[:attrs]).to eq(my_attrs)
    end

    it 'should return @debug_attrs' do
      expect(subject.locate_cargo[:cargo_accessed]).to eq(true)
    end

    it 'should contained attrs from within block' do
      expect(subject.locate_cargo_with_shadowed_attrs_hsh[:cargo_accessed]). to eq({})
    end
  end
end
