Given("the box title is {string}") do |string|
  @box_str = string
end

Then("I should have a copy of the response body in a CSV") do
  expect(@book_details_hsh[:response_code]).to eq(@book_details_csv[:response_code].first)
  expect(@book_details_hsh[:isbn]).to eq(@book_details_csv[:isbn].first)
  expect(@book_details_hsh[:box]).to eq(@book_details_csv[:box].first)
  expect(@book_details_hsh[:long_title]).to eq(@book_details_csv[:long_title].first)
  expect(@book_details_hsh[:author]).to eq(@book_details_csv[:author].first)
  expect(@book_details_hsh[:publisher]).to eq(@book_details_csv[:publisher].first)
  expect(@book_details_hsh[:binding_type]).to eq(@book_details_csv[:binding_type].first)
  expect(@book_details_hsh[:pages]).to eq(@book_details_csv[:pages].first.to_i) unless @book_details_hsh[:pages] == "N/A"
  expect(@book_details_hsh[:date_published]).to eq(@book_details_csv[:date_published].first)
end

Then("in the API response the box title should be {string}") do |string|
  expect(@book_details_hsh[:box]).to eq(string)
end

Then("in the API response the long title of the book should be {string}") do |string|
  expect(@book_details_hsh[:long_title]).to eq(string)
end

Then("in the API response the the author of the book should be {string}") do |string|
  expect(@book_details_hsh[:author]).to eq(string)
end

Then("in the API response the the publisher of the book should be {string}") do |string|
  expect(@book_details_hsh[:publisher]).to eq(string)
end

Then("in the API response the the binding of the book should be {string}") do |string|
  expect(@book_details_hsh[:binding_type]).to eq(string)
end

Then("in the API response the the book should have {string} pages") do |string|
  pages_input = string == 'N/A' ? string : string.to_i
  expect(@book_details_hsh[:pages]).to eq(pages_input)
end

Then("in the API response the the publication date of the book should be {string}") do |string|
  expect(@book_details_hsh[:date_published]).to eq(string)
end

Then("in the CSV the long title of the book should be {string}") do |string|
  expect(@book_details_hsh[:long_title]).to eq(string)
end

Then("in the CSV the box title should be {string}") do |string|
  expect(@book_details_hsh[:box]).to eq(string)
end

Then("in the CSV the the author of the book should be {string}") do |string|
  expect(@book_details_hsh[:author]).to eq(string)
end

Then("in the CSV the the publisher of the book should be {string}") do |string|
  expect(@book_details_hsh[:publisher]).to eq(string)
end

Then("in the CSV the the binding of the book should be {string}") do |string|
  expect(@book_details_hsh[:binding_type]).to eq(string)
end

Then("in the CSV the the book should have {string} pages") do |string|
  expect(@book_details_hsh[:pages]).to eq(string.to_i)
end

Then("in the CSV the the publication date of the book should be {string}") do |string|
  expect(@book_details_hsh[:date_published]).to eq(string)
end
