When("I input the jumbled words {string}") do |jumbled_words|
  @jumbled_words = jumbled_words
end

Then("the jumbled words should be sorted like this {string}") do |sorted_words|
  expect(order(@jumbled_words)).to eq(sorted_words)
end
