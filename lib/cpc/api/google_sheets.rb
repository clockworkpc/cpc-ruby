require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'

module Cpc
  module Api
    class GoogleSheets
      include Cpc::Util::ApiUtil
      include Cpc::Util::CollectionUtil

      def initialize(username)
        credentials_dir = 'credentials'
        credentials_basename = "#{username}-credentials.json"
        @credentials_path = [credentials_dir, credentials_basename].join('/')
      end

      CLIENT_ID = ENV['GOOGLE_SHEETS_CLIENT_ID']
      CLIENT_SECRET = ENV['GOOGLE_SHEETS_CLIENT_SECRET']
      OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
      APPLICATION_NAME = 'CPC Demo Google Sheets'
      TOKEN_PATH = 'token.yaml'
      SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

      def authorize
        client_id = Google::Auth::ClientId.from_file(@credentials_path)
        token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
        authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store
        user_id = 'default'
        credentials = authorizer.get_credentials user_id
        if credentials.nil?
          url = authorizer.get_authorization_url base_url: OOB_URI
          puts 'Open the following URL in the browser and enter the ' \
          "resulting code after authorization:\n" + url
          # code = gets
          code = nil

          binding.pry

          credentials = authorizer.get_and_store_credentials_from_code(
            user_id: user_id, code: code, base_url: OOB_URI
          )
        end
        credentials
      end

      def start_service
        service = Google::Apis::SheetsV4::SheetsService.new
        service.client_options.application_name = APPLICATION_NAME
        service.authorization = authorize
        service
      end

      def get_values_from_spreadsheet(args_hsh)
        range = "#{args_hsh[:sheet]}!#{args_hsh[:range_start]}:#{args_hsh[:range_end]}"
        service = start_service
        response = service.get_spreadsheet_values(args_hsh[:spreadsheetId], range)
      end

      def convert_spreadsheet_to_hash_array(spreadsheet)
        key_ary = spreadsheet.values[0]
        ary_ary = spreadsheet.values[1..-1]
        hsh_ary = convert_nested_array_to_hash_array(key_ary, ary_ary)
        hsh_ary.map { |hsh| hsh.symbolize_keys }
      end

      def create_reference_hash_array(args_hsh)
        spreadsheet = get_values_from_spreadsheet(args_hsh)
        convert_spreadsheet_to_hash_array(spreadsheet)
      end

      def collect_ranges_from_ref_hsh_ary(ref_hsh_ary)
        range_hsh_ary = Array.new
        collected_range_ary = Array.new
        ref_hsh_ary.each do |ref_hsh|
          range_ary_ary = get_values_from_spreadsheet(ref_hsh).values
          collected_range_ary << [ref_hsh, range_ary_ary]
        end
        collected_range_ary.each do |ary|
          key_ary = ary[0][:headers].split("|")
          ary_ary = ary[1]
          values_hsh_ary = convert_nested_array_to_hash_array(key_ary, ary_ary)
          range_hsh_ary << {spreadsheet_details: ary[0], spreadsheet_values: values_hsh_ary }
        end

        range_hsh_ary
      end

      def collect_ranges_from_reference_sheet(spreadsheetId_str)
        ref_hsh_ary = create_reference_hash_array(spreadsheetId_str)
        ranges = collect_ranges_from_ref_hsh_ary(ref_hsh_ary)
      end

    end
  end
end
