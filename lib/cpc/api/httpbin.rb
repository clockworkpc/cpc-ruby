require_relative '../util/api_util'
require 'base64'

module Cpc
  module Api
    class Httpbin
      include Cpc::Util::ApiUtil

      attr_reader :host

      def initialize(host_url)
        if host_url.nil?
          @host = 'https://httpbin.org'
        else
          @host = host_url
        end
      end

      def uuid?(str)
        str.match?(/[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+\-[a-z0-9]+/)
      end

      def naked_get
        args_hsh = { url: { host: @host, path: 'get' } }
        api_get_request(args_hsh)
      end

      def naked_post
        args_hsh = { url: { host: @host, path: 'post'} }
        api_post_request(args_hsh)
      end

      def naked_patch
        args_hsh = { url: { host: @host, path: 'patch'} }
        api_patch_request(args_hsh)
      end

      def naked_put
        args_hsh = { url: { host: @host, path: 'put'} }
        api_put_request(args_hsh)
      end

      def naked_delete
        args_hsh = { url: { host: @host, path: 'delete'} }
        api_delete_request(args_hsh)
      end

      def basic_auth(user_str, password_str)
        args_hsh = {
          url:
          {
            host: @host,
            path: 'basic-auth',
            user: user_str,
            password: password_str
          },
          request_headers: {
            'accept': 'application/json',
            'Connection': 'keep-alive',
            'Accept-Encoding': 'gzip, deflate, br',
            'Referer': 'https://httpbin.org/'
          }
        }

        api_get_request(args_hsh)
      end

      def bearer(auth_token_str)
        args_hsh = {
          url: {
            host: @host,
            path: 'bearer'
          },
          request_headers: {
            "accept": "application/json",
            "Authorization": auth_token_str
          }
        }

        api_get_request(args_hsh)
      end

      def request_ip
        args_hsh = {
          url: {
            host: @host,
            path: 'ip'
          }
        }
        api_get_request(args_hsh)
      end

      def request_headers
        args_hsh = { url: { host: @host, path: 'headers' } }
        api_get_request(args_hsh)
      end

      def response_headers(str)
        args_hsh = {
          url: { host: @host, path: 'response-headers' },
          url_params: { "freeform": str }
        }
        api_get_request(args_hsh)
      end

      def post_response_headers(str)
        args_hsh = {
          url: { host: @host, path: 'response-headers' },
          url_params: { "freeform": str }
        }
        api_post_request(args_hsh)
      end

      def get_deflate_data
        args_hsh = { url: { host: @host, path: 'deflate' } }
        api_get_request(args_hsh)
      end

      def get_deny
        args_hsh = { url: { host: @host, path: 'deny' } }
        api_get_request(args_hsh)
      end

      def get_utf8
        args_hsh = {
          url: { host: @host, path: 'encoding', type: 'utf8' },
          request_headers: { accept: 'text/html;charset=utf-8' }
        }
        api_get_request(args_hsh)
      end

      def get_gzip
        args_hsh = {
          url: { host: @host, path: 'gzip' },
          request_headers: { accept: 'application/json' }
        }
        api_get_request(args_hsh)
      end

      def get_html
        args_hsh = { url: { host: @host, path: 'html' } }
        api_get_request(args_hsh)
      end

      def get_json
        args_hsh = {
          url: { host: @host, path: 'json' },
          request_headers: { accept: 'application/json' }
        }
        api_get_request(args_hsh)
      end

      def get_robots_txt
        args_hsh = { url: { host: @host, path: 'robots.txt' } }
        api_get_request(args_hsh)
      end

      def get_xml
        args_hsh = { url: { host: @host, path: 'xml' } }
        api_get_request(args_hsh)
      end

      def get_base64(input_str)
        input_base64 = URI.encode(Base64.encode64(input_str))
        args_hsh = {
          url: { host: @host, path: 'base64', input: input_base64 },
          request_headers: { accept: 'text/html' }
        }
        api_get_request(args_hsh)
      end

      def get_uuid
        args_hsh = { url: { host: @host, path: 'uuid' } }
        api_get_request(args_hsh)
      end

      def get_empty_cookies
        args_hsh = { url: { host: @host, path: 'cookies' } }
        api_get_request(args_hsh)
      end

      def delete_cookie(str)
        args_hsh = {
          url: { host: @host, path: 'cookies', type: 'delete' },
          url_params: { "freeform": str },
          request_headers: {
            connection: "keep-alive",
            accept: 'text/plain',
            'access-control-allow-origin': '*',
            'access-control-allow-credentials': true ,
            'content-length': 20,
            'content-type': 'application/json'
          }
        }
        api_get_request(args_hsh)
      end

      def post_pizza_order(order_hsh)
        args_hsh = {
          url: {
            host: @host,
            path: 'post'
          },
          request_headers: {
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
            "Accept-Encoding": "gzip, deflate",
            "Accept-Language": "en-GB,en-US;q=0.9,en;q=0.8",
            "Cache-Control": "max-age=0",
            "Connection": "keep-alive",
            "Content-Type": "application/x-www-form-urlencoded",
            "Upgrade-Insecure-Requests": "1",
          },
          request_body: order_hsh
        }
        res = api_post_request(args_hsh)
        form_str = res.body["form"].keys.first
        form_hsh = JSON.parse(form_str)
        res.body["form"] = form_hsh
        res
      end


    end
  end
end
