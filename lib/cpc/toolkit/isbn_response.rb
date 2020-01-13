require 'rainbow'
require_relative '../util/api_util'
require_relative '../util/file_parse_util'
require_relative '../util/generate_data_util'

module Cpc
  module Toolkit
    class IsbnResponse
      attr_reader :code, :body, :headers, :box

      def initialize(code_int, body_hsh, headers_hsh, box_str)
        @code = code_int
        @body = body_hsh
        @headers = headers_hsh
        @box = box_str
      end

      def temporary_headers
        @body['headers']
      end

      def method
        @body['method']
      end

      def origin
        @body['origin']
      end

      def publisher
        @body['publisher']
      end

      def synopsis
        @body['synopsys']
      end

      def image
        @body['image']
      end

      def title_long
        @body['title_long']
      end

      def pages
        @body['pages']
      end

      def date_published
        @body['date_published']
      end

      def authors
        @body['authors']
      end

      def title
        @body['title']
      end

      def isbn13
        @body['isbn13']
      end

      def msrp
        @body['msrp']
      end

      def binding
        @body['binding']
      end

      def publish_date
        @body['publish_date']
      end

      def isbn
        @body['isbn']
      end
    end
  end
end
