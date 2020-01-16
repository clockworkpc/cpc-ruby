# frozen_string_literal: true
require 'uri'
require 'net/http'
require 'nokogiri'
require_relative 'string_util'
require_relative 'collection_util'

module Cpc
  module Util
    class ApiResponse
      include Cpc::Util::StringUtil
      include Cpc::Util::CollectionUtil

      attr_reader :code, :body, :headers

      def initialize(res_obj, encoding_str)
        @res = res_obj
        @code = res_obj.code.to_i
        @body = parse_response_body(encoding_str)
        @headers = collect_headers
      end

      def parse_response_body(encoding_str)
        parsed_res = nil
        actual_encoding = @res.body.encoding.to_s

        case
        when @res.body.nil?
          # puts 'No body'
        when actual_encoding.eql?(encoding_str)
          # puts "Encoding already #{actual_encoding}"
        else
          @res.body = @res.body.force_encoding('UTF-8')
        end

        if @res.body.encoding.to_s.eql?('UTF-8')
          case
          when @res.body.blank?
            puts 'Body is blank'
          when valid_json?(@res.body)
            parsed_res = JSON.parse(@res.body)
          when html?(@res.body)
            parsed_res = Nokogiri::HTML(@res.body)
          when xml?(@res.body)
            parsed_res = Nokogiri::XML(@res.body)
          else
            parsed_res = @res.body
          end
        else
          parsed_res = @res.body
        end

        parsed_res
      end

      def collect_headers
        headers_hsh = Hash.new
        @res.to_hash.each { |k, v| headers_hsh[k] = v.first }
        headers_hsh
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
    end
  end
end
