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

      def get_all_contacts
        args_hsh = { url: { host: @host, path: 'contact' } }
        api_get_request(args_hsh)
      end

      def get_contact(id_str)
        args_hsh = { url: { host: @host, path: 'contact', _id: id_str } }
        api_get_request(args_hsh)
      end

      def post_contact(contact_hsh)
        request_body_uri = URI.encode(contact_hsh.map {|k,v| "#{k}=#{v}"}.join('&'))
        args_hsh = {
          url: { host: @host, path: 'contact' },
          request_body: request_body_uri
        }
        api_post_request(args_hsh)
      end

      def put_contact(contact_hsh)
        request_body_uri = URI.encode(contact_hsh.map {|k,v| "#{k}=#{v}"}.join('&'))
        args_hsh = {
          url: { host: @host, path: 'contact', _id: contact_hsh[:_id] },
          request_body: request_body_uri
        }
        api_put_request(args_hsh)
      end

      def delete_contact(contactID_str)
        args_hsh = { url: { host: @host, path: 'contact', contact_id: contactID_str } }
        api_delete_request(args_hsh)
      end

      def delete_latest_contact(protected_id_ary = nil)
        all_contacts = get_all_contacts.body
        deletable_contacts = all_contacts.reject { |h| protected_id_ary.include?(h['_id']) }
        deletable_ids = deletable_contacts.map { |h| h['_id'] }
        # expect(deletable_ids.count).to eq(all_contacts.count - 2)
        id_to_delete = deletable_ids.last
        delete_contact(id_to_delete)
      end
    end
  end
end
