require 'spec_helper'

RSpec.describe Cpc::Codewars::MinecraftFurnaceFuel do
  include Cpc::Codewars::MinecraftFurnaceFuel

  let(:fuel_hsh_37) { {:lava=>0, :blaze_rod=>3, :coal=>0, :wood=>3, :stick=>2} }
  # let(:fuel_hsh_21) { {:lava=>0, :blaze_rod=>1, :coal=>1, :wood=>2, :stick=>1} }
  # let(:fuel_hsh_123) { {:lava=>1, :blaze_rod=>4, :coal=>0, :wood=>4, :stick=>13} }

  it 'should calculate fuel for 37 ingots', offline: true do
    expect(calc_fuel(37)).to eq(fuel_hsh_37)
  end

end
