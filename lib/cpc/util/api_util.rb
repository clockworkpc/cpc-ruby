# frozen_string_literal: true

require 'uri'
require 'net/http'
require_relative 'api_response'
require_relative 'string_util'
require_relative 'collection_util'

module Cpc
  module Util
    module ApiUtil
      include Cpc::Util::StringUtil
      include Cpc::Util::CollectionUtil

      def hello_api
        'hello_api'
      end

      def construct_url_with_path_and_params(url_hsh, url_params_hsh = nil)
        url = url_hsh.values.join('/')

        unless url_params_hsh.nil?
          url_params_hsh.each { |k,v| url = [url, "#{k}=#{v}"].join('?') }
        end

        puts Rainbow(URI.escape(url)).yellow
        URI.escape(url)
      end

      def create_request(type_str, uri)
        request = nil
        case type_str
        when 'get'
          request = Net::HTTP::Get.new(uri)
        when 'post'
          request = Net::HTTP::Post.new(uri)
        when 'put'
          request = Net::HTTP::Put.new(uri)
        when 'delete'
          request = Net::HTTP::Delete.new(uri)
        when 'patch'
          request = Net::HTTP::Patch.new(uri)
        end
        request
      end

      def add_body_to_request(request, body_input)
        # TODO: differentiate between form-data, x-wwww-form-urlencoded, raw, binary, graphql

        case
        when body_input.is_a?(String) && valid_json?(body_input)
          request_body = JSON.parse(body_input)
        when body_input.is_a?(String) && URI.parse(body_input).is_a?(URI)
          request_body = body_input
        when body_input.is_a?(Hash)
          request_body = body_input.stringify_keys.to_json
        when body_input.nil?
          request_body = nil
        else
          request_body = body_input.map { |k, v| [k.to_s, v] }.to_h.stringify_keys.to_json
        end

        request.body = request_body
        request
      end

      def add_headers_to_request(request, headers_hsh)
        headers_hsh.each { |k ,v| request[k] = v } unless headers_hsh.nil?
        request
      end

      def api_request(type_str, args_hsh, encoding_str)
        url = construct_url_with_path_and_params(args_hsh[:url], args_hsh[:url_params])
        uri = URI(url)

        http = Net::HTTP.new(uri.host, uri.port)
        on_local_pc = uri.host.eql?('0.0.0.0') || uri.host.eql?('localhost')
        http.use_ssl = true unless on_local_pc

        request = create_request(type_str, uri)
        add_headers_to_request(request, args_hsh[:request_headers])
        add_body_to_request(request, args_hsh[:request_body])

        res_obj = http.request(request)
        response_300_range = res_obj.code.to_i >= 300 && res_obj.code.to_i < 400

        if response_300_range
          url = [args_hsh[:url][:host], res_obj['location']].join
          uri = URI(url)
          puts "Redirecting to #{url}"

          request = create_request(type_str, uri)
          add_headers_to_request(request, args_hsh[:request_headers])
          add_body_to_request(request, args_hsh[:request_body])

          res_obj = http.request(request)
        end

        Cpc::Util::ApiResponse.new(res_obj, encoding_str)
      end

      def api_get_request(args_hsh, encoding = 'UTF-8')
        api_request('get', args_hsh, encoding)
      end

      def api_post_request(args_hsh, encoding = 'UTF-8')
        api_request('post', args_hsh, encoding)
      end

      def api_put_request(args_hsh, encoding = 'UTF-8')
        api_request('put', args_hsh, encoding)
      end

      def api_delete_request(args_hsh, encoding = 'UTF-8')
        api_request('delete', args_hsh, encoding)
      end

      def api_patch_request(args_hsh, encoding = 'UTF-8')
        api_request('patch', args_hsh, encoding)
      end

    end
  end
end
