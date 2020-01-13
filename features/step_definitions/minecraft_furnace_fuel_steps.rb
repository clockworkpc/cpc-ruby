Given("I need to produce {string} ingots for my Minecraft railway") do |string|
  ingots_int = string.to_i
  @fuel_hsh = calc_fuel(ingots_int)
end


Then("I should need {string} buckets of lava for the furnace") do |string|
  expect(@fuel_hsh[:lava]).to eq(string.to_i)
end

Then("I should need {string} blaze rods for the furnace") do |string|
  expect(@fuel_hsh[:blaze_rod]).to eq(string.to_i)
end

Then("I should need {string} lumps of coal for the furnace") do |string|
  expect(@fuel_hsh[:coal]).to eq(string.to_i)
end

Then("I should need {string} blocks of wood for the furnace") do |string|
  expect(@fuel_hsh[:wood]).to eq(string.to_i)
end

Then("I should need {string} sticks for the furnace") do |string|
  expect(@fuel_hsh[:stick]).to eq(string.to_i)
end
