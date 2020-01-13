require 'rainbow'
require_relative '../util/api_util'
require_relative '../util/file_parse_util'
require_relative '../util/generate_data_util'
require_relative 'isbn_response'

module Cpc
  module Toolkit
    class IsbnFetcher
      include Cpc::Util::ApiUtil
      include Cpc::Util::GenerateDataUtil

      def initialize(api_key_str)
        @api_key = ENV[api_key_str]
        @host = 'https://api2.isbndb.com'
      end

      def isbn_response(code_int, body_hsh, headers_hsh, box_str)
        Cpc::Toolkit::IsbnResponse.new(code_int, body_hsh, headers_hsh, box_str)
      end

      def book_detail_keys
        [:response_code, :box, :publisher, :synopsys, :image, :title_long, :pages, :date_published, :authors, :title, :isbn13, :msrp, :binding, :publish_date, :isbn]
      end

      def isbn_db_args(isbn_str)
        {
          url: {
            host: @host,
            path: 'book',
            isbn: isbn_str
          },
          url_params: {
            'with_prices': 0
          },
          request_headers: {
            "accept": 'application/json',
            "Authorization": ENV['ISBN_DB_API_KEY'],
            "cache-control": 'no-cache'
          }
        }
      end

      def detail_value(value)
        value.nil? ? "N/A" : value
      end

      def collect_book_details(book_obj)
        details_hsh = {}
        details_hsh[:response_code] = book_obj.code
        details_hsh[:box] = book_obj.box
        book_obj.body['book'].each { |k, v| details_hsh[k] = detail_value(v) }
        details_hsh
      end

      def collect_details_book_found_true(book_obj)
      # def collect_details_book_found_true(isbn_str, box_str, response_code, book_hsh)
        details_hsh = {}

        details_hsh[:response_code] = book_obj.code
        details_hsh[:isbn] = book_obj.isbn
        details_hsh[:box] = book_obj.box

        # details_hsh[:response_code] = response_code
        # details_hsh[:isbn] = isbn_str
        # details_hsh[:box] = box_str

        long_title = detail_value(book_obj.title_long)
        author = book_hsh['authors'].nil? ? "N/A" : book_hsh["authors"].first
        publisher = detail_value(book_hsh["publisher"])
        binding_type = detail_value(book_hsh["binding"])
        pages = detail_value(book_hsh["pages"])
        date_published = detail_value(book_hsh["publish_date"])

        details_hsh[:long_title] = long_title
        details_hsh[:author] = author
        details_hsh[:publisher] = publisher
        details_hsh[:binding_type] = binding_type
        details_hsh[:pages] = pages
        details_hsh[:date_published] = date_published

        details_hsh
      end

      def collect_details_book_found_false(isbn_str, box_str, response_code)
        details_hsh = {}
        details_hsh[:response_code] = response_code
        details_hsh[:isbn] = isbn_str
        details_hsh[:box] = box_str
        details_hsh[:long_title] = "N/A"
        details_hsh[:author] = "N/A"
        details_hsh[:publisher] = "N/A"
        details_hsh[:binding_type] = "N/A"
        details_hsh[:pages] = "N/A"
        details_hsh[:date_published] = "N/A"
        details_hsh
      end

      def add_missing_book_details(details_hsh)
        missing_keys = book_detail_keys - details_hsh.keys
        missing_keys.each {|k| details_hsh[k] = 'N/A'}
        details_hsh
      end

      def collect_book_details(isbn_str, box_str)
        details_hsh = {}

        puts "Fetching book details for #{isbn_str} in #{box_str} box"
        args_hsh = isbn_db_args(isbn_str)
        res = api_get_request(args_hsh)
        book_obj = isbn_response(res.code, res.body, res.headers, box_str)

        details_hsh[:response_code] = book_obj.code
        details_hsh[:box] = book_obj.box
        book_obj.body['book'].each { |k, v| details_hsh[k.to_sym] = detail_value(v) }
        add_missing_book_details(details_hsh)
        details_hsh
      end

      def write_to_csv(details_hsh, csv_path)
        csv = csv_from_simple_hsh_with_header(details_hsh)
        f = File.open(csv_path, 'w')
        f.write(csv)
        f.close
      end

      def append_to_csv(details_hsh, csv_path)
        csv = csv_from_simple_hsh_sans_header(details_hsh)
        f = File.open(csv_path, 'a')
        f.write(csv)
        f.close
      end

      def save_to_csv(details_hsh, csv_path)
        no_headers = File.exist?(csv_path) == false || File.empty?(csv_path)
        write_to_csv(details_hsh, csv_path) if no_headers
        append_to_csv(details_hsh, csv_path) unless no_headers
      end

      def batch_fetch_save_to_csv(isbn_hsh_ary, csv_path)
        countdown = isbn_hsh_ary.count
        countup = 0

        isbn_hsh_ary.each do |isbn_hsh, box_str|
          isbn_str = isbn_hsh[:isbn]
          box_str = isbn_hsh[:box]

          details_hsh = collect_book_details(isbn_str, box_str)
          save_to_csv(details_hsh, csv_path)

          countdown -= 1
          countup += 1
          puts "ISBNs checked: #{countup}"
          puts "Books remaining: #{countdown}"
        end
      end
    end
  end
end
