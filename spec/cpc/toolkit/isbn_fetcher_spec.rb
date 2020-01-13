# require 'spec_helper'
#
# RSpec.describe Cpc::Toolkit::IsbnFetcher do
#   include Cpc::Util::FileParseUtil
#
#   let(:title_long) {"Knitting Vintage Socks"}
#   let(:authors) {"Nancy Bush"}
#   let(:publisher) {"Interweave"}
#   let(:binding_type) {"Spiral-bound"}
#   let(:pages) {128}
#   let(:date_published) {"2005"}
#
#   let(:empty_file_path) {'spec/fixtures/empty_file.csv'}
#   let(:isbn_csv_path) {'spec/output/isbn_csv_with_headers.csv'}
#
#   let(:isbn_hsh) do
#     { response_code: '200',
#       isbn: '9781931499651',
#       title_long: 'Knitting Vintage Socks',
#       authors: 'Nancy Bush',
#       publisher: 'Interweave',
#       binding: 'Spiral-bound',
#       pages: 128,
#       date_published: '2005' }
#   end
#
#   let(:isbn_hsh_half_empty) do
#     {:isbn=>"9780957740358",
#       :response_code=>"200",
#       :title_long=>"Eye_spy_who_am_i",
#       :authors=>"N/A",
#       :publisher=>"Melbourne : Borghesi & Adam Publishers, 2001.",
#       :binding_type=>"N/A",
#       :pages=>"N/A",
#       :date_published=>"N/A"}
#   end
#
#   let(:header_sym_ary) { [:response_code, :box, :publisher, :synopsys, :image, :title_long, :pages, :date_published, :authors, :title, :isbn13, :msrp, :binding, :publish_date, :isbn] }
#
#   context 'Authorised API key', online: true do
#     subject = Cpc::Toolkit::IsbnFetcher.new('ISBN_DB_API_KEY')
#     context 'ISBN 9781931499651' do
#       isbn_str = '9781931499651'
#       box_str = '01 Craft'
#
#       before(:all) do
#         @book_details = subject.collect_book_details(isbn_str, box_str)
#       end
#
#       it 'should have the right headers' do
#         expect(@book_details.keys).to eq(header_sym_ary)
#       end
#
#       it 'should return book title from ISBNdb' do
#         expect(@book_details[:isbn13]).to eq(isbn_str)
#       end
#
#       it 'should return book title from ISBNdb' do
#         expect(@book_details[:box]).to eq(box_str)
#       end
#
#       it 'should return book title from ISBNdb' do
#         expect(@book_details[:title_long]).to eq(title_long)
#       end
#
#       it 'should return author from ISBNdb' do
#         expect(@book_details[:authors].first).to eq(authors)
#       end
#
#       it 'should return publisher from ISBNdb' do
#         expect(@book_details[:publisher]).to eq(publisher)
#       end
#
#       it 'should return binding from ISBNdb' do
#         expect(@book_details[:binding]).to eq(binding_type)
#       end
#
#       it 'should return page count from ISBNdb' do
#         expect(@book_details[:pages]).to eq(pages)
#       end
#
#       it 'should return publication date from ISBNdb' do
#         expect(@book_details[:date_published]).to eq(date_published)
#       end
#     end
#
#     context 'ISBN 9780957740358' do
#       isbn_str = '9780957740358'
#       box_str = "04 Children's Books"
#
#       before(:all) do
#         @book_details = subject.collect_book_details(isbn_str, box_str)
#       end
#
#       it 'should have the right headers' do
#         keys = [:response_code, :box, :publisher, :image, :title_long, :title, :isbn13, :msrp, :isbn, :synopsys, :pages, :date_published, :authors, :binding, :publish_date]
#         expect(@book_details.keys).to eq(keys)
#       end
#
#       it 'should return ISBN' do
#         expect(@book_details[:isbn13]).to eq(isbn_str)
#       end
#
#       it 'should return box title' do
#         expect(@book_details[:box]).to eq(box_str)
#       end
#
#       it 'should return book title from ISBNdb' do
#         expect(@book_details[:title_long]).to eq(isbn_hsh_half_empty[:title_long])
#       end
#
#       it 'should return author from ISBNdb' do
#         expect(@book_details[:authors]).to eq(isbn_hsh_half_empty[:authors])
#       end
#
#       it 'should return publisher from ISBNdb' do
#         expect(@book_details[:publisher]).to eq(isbn_hsh_half_empty[:publisher])
#       end
#
#       it 'should return binding from ISBNdb' do
#         expect(@book_details[:binding]).to eq(isbn_hsh_half_empty[:binding_type])
#       end
#
#       it 'should return page count from ISBNdb' do
#         expect(@book_details[:pages]).to eq(isbn_hsh_half_empty[:pages])
#       end
#
#       it 'should return publication date from ISBNdb' do
#         expect(@book_details[:date_published]).to eq(isbn_hsh_half_empty[:date_published])
#       end
#     end
#   end
#
#   context 'Book details fetched', offline: true do
#     subject = Cpc::Toolkit::IsbnFetcher.new('')
#
#     it 'should write to csv' do
#       subject.write_to_csv(isbn_hsh, isbn_csv_path)
#       expect(parse_csv_file(isbn_csv_path).count).to eq(1)
#     end
#
#     it 'should append_to_csv' do
#       subject.save_to_csv(isbn_hsh, isbn_csv_path)
#       expect(parse_csv_file(isbn_csv_path).count).to eq(2)
#     end
#
#   end
# end
