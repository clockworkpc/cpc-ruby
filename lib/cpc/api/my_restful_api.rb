require_relative '../util/api_util'

module Cpc
  module Api
    class MyRestfulApi
      include Cpc::Util::ApiUtil

      def initialize(url, port_int)
        @host = [url, port_int].join(':')
      end

      def get_root
        args_hsh = { url: { host: @host } }
        api_get_request(args_hsh)
      end

      def get_contact
        args_hsh = { url: { host: @host, path: 'contact' } }
        api_get_request(args_hsh)
      end

      def post_contact
        args_hsh = { url: { host: @host, path: 'contact' } }
        api_post_request(args_hsh)
      end

      def put_contact(contactID_str)
        args_hsh = { url: { host: @host, path: 'contact', contact_id: contactID_str } }
        api_put_request(args_hsh)
      end

      def delete_contact(contactID_str)
        args_hsh = { url: { host: @host, path: 'contact', contact_id: contactID_str } }
        api_delete_request(args_hsh)
      end
    end
  end
end
