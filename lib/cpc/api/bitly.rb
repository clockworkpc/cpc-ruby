require_relative '../util/api_util'
require 'base64'

module Cpc
  module Api
    class Bitly
      include Cpc::Util::ApiUtil

      def host_url
        "https://api-ssl.bitly.com"
      end

      def domain
        'bit.ly'
      end

      def standard_request_headers
        {
          'Accept-Encoding' => 'application/json',
          'Authorization' => ENV['BITLY_API_KEY'],
          'Content-Type' => 'application/json'
        }
      end

      def oauth_token
        ENV['BITLY_OAUTH_TOKEN']
      end

      def shorten(long_url)
        args_hsh = {
          url: { host: host_url, version: 'v4', path: 'shorten' },
          request_body: { 'long_url' => long_url },
          request_headers: standard_request_headers
        }
        api_post_request(args_hsh)
      end

      def expand(bitlink_url)
        bitlink_id_str = bitlink_url.sub('http://', '')

        args_hsh = {
          url: { host: host_url, version: 'v4', path: 'expand' },
          request_body: { 'bitlink_id' => bitlink_id_str },
          request_headers: standard_request_headers
        }

        api_post_request(args_hsh)
      end

      def retrieve(bitlink_url)
        bitlink_id_str = bitlink_url.sub('http://', '')

        args_hsh = {
          url: {
            host: host_url,
            version: 'v4',
            path: 'bitlinks',
            bitlink: bitlink_id_str
          },
          request_headers: standard_request_headers
        }

        api_get_request(args_hsh)
      end
    end
  end
end
