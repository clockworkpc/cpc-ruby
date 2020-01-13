Given("a standard string {string}") do |standard_string|
  @standard_string = standard_string
end

Then("camelcase should return {string}") do |output_string|
  expect(camelcase(@standard_string)).to eq(output_string)
end
