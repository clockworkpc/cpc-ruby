Given("I make an API call to {string} with {string}") do |string1, string2|
  case
  when string1 == "ISBNdb"
    isbn_str = string2
    isbn = Cpc::Toolkit::IsbnFetcher.new('ISBN_DB_API_KEY')
    @book_details_hsh = isbn.collect_book_details(isbn_str, @box_str)
  end
end

Given("the API response code is {string}") do |string|
  expect(@book_details_hsh[:response_code]).to eq(string)
end

When("I parse the API response body and write it to {string}") do |string|
  case string
  when "ISBN CSV"
    output_path = 'spec/output/isbn_details.csv'
    csv_obj = Cpc::Util::GenerateDataUtil.csv_from_simple_hsh_with_header(@book_details_hsh)
    f = File.open(output_path, 'w')
    f.write(csv_obj)
    f.close
    @book_details_csv = Cpc::Util::FileParseUtil.parse_csv_file(output_path)
  end
end
