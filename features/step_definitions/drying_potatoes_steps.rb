Given("the potato water ratio is {string} percent") do |water_percent_str|
  @initial_water_percent = water_percent_str.to_i
end

Given("the potato weight is {string} kilograms") do |potato_weight_str|
  @initial_weight = potato_weight_str.to_i
end

When("the potato water ratio changes to {string} percent") do |water_percent_str|
  @final_water_percent = water_percent_str.to_i
end

Then("the potato weight should be {string} kilograms") do |potato_weight_str|
  calculated_final_weight = potatoes(@initial_water_percent, @initial_weight, @final_water_percent)
  expect(calculated_final_weight).to eq(potato_weight_str.to_i)
end
