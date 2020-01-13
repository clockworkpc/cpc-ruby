Given("I input five numbers {string}") do |n_str|
  @input_int_ary = n_str.split(',').map { |s| s.to_i }
end

Then("I should calculate a five number summary {string}") do |n_str|
  @output_fr_ary = n_str.split(',').map { |s| s.to_f }
  expect(five_num(@input_int_ary)).to eq(@output_fr_ary)
end
