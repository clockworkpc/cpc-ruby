Given("I have an array that contains {string} elements") do |string|
  @array_length = string.to_i
end

Given("I want matching elements at {string} fixed points") do |string|
  @haps_int = string.to_i
end

Then("the number of special permutations should be {string}") do |string|
  expect(fixed_point_perms(@array_length, @haps_int)).to eq(string.to_i)
end
