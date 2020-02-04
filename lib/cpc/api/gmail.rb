require "google/apis/gmail_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"
require 'pry'

module Cpc
  module Api
    class Gmail
      include Cpc::Util::ApiUtil
      include Cpc::Util::CollectionUtil

      def initialize(username)
        credentials_dir = 'config/credentials'
        tokens_dir = 'config/tokens'

        credentials_basename = "#{username}-gmail-credentials.json"
        token_basename = "#{username}-gmail-token.json"

        @credentials_path = [credentials_dir, credentials_basename].join('/')
        @token_path = [tokens_dir, token_basename].join('/')
      end

      OOB_URI = "urn:ietf:wg:oauth:2.0:oob".freeze
      APPLICATION_NAME = "Gmail API Ruby Quickstart".freeze
      SCOPE = Google::Apis::GmailV1::AUTH_GMAIL_READONLY

      def authorize
        client_id = Google::Auth::ClientId.from_file(@credentials_path)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: @token_path)
        authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
        user_id = "default"
        credentials = authorizer.get_credentials user_id

        if credentials.nil?
          url = authorizer.get_authorization_url base_url: OOB_URI
          puts "Open the following URL in the browser and enter the " \
               "resulting code after authorization:\n" + url

         # code = gets
         code = nil
         binding.pry

         credentials = authorizer.get_and_store_credentials_from_code(
           user_id: user_id,
           code: code,
           base_url: OOB_URI)
        end
        credentials
      end

      def start_service
        service = Google::Apis::GmailV1::GmailService.new
        service.client_options.application_name = APPLICATION_NAME
        service.authorization = authorize
        service
      end

      def all_user_labels
        service = start_service
        user_id = "me"
        result = service.list_user_labels user_id
        puts "Labels:"
        puts "No labels found" if result.labels.empty?
        binding.pry
        result.labels.each { |label| puts "- #{label.name}" }
      end
    end
  end
end
