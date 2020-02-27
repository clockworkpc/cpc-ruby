require 'spec_helper'
require 'cpc/study/constants'

RSpec.describe Cpc::Study::Constants do

  context 'without :freeze method: ', offline: true do
    it 'a Constant can be modified' do
      MAX_SPEED = 1000
      MAX_SPEED = 100

      expect(MAX_SPEED).to eq(100)
    end
  end

  context 'with :freeze method', offline: true do
    it 'modifying the object that a Constant points to raises a FrozenError' do
      VEHICLES = []
      VEHICLES.freeze
      expect {VEHICLES << "train"}.to raise_exception(FrozenError)
    end

    it 'an element inside a frozen object can be modified' do
      NAMES = ["Alex", "Andrew"]
      expect { NAMES[0].upcase! }.not_to raise_exception
      expect(NAMES[0]).to eq("ALEX")
    end

    it 'a Constant can nevertheless be reassigned to a different object' do
      SOME_CONSTANT = ["hello world"]
      SOME_CONSTANT.freeze
      expect {SOME_CONSTANT = ["goodbye world"]}.not_to raise_exception
      expect(SOME_CONSTANT).to eq(["goodbye world"])
    end

  end
end
