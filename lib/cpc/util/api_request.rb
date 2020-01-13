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


    end
  end
end
