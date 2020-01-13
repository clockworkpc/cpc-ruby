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



      def create_reference_hash(ary_ary, spreadsheetId_str)
        tab_hsh = Hash.new
        ary_ary.each do |ary|
          sheet_str = ary[0],
          range_start_str = ary[1],
          range_end_str = ary[2]

          tab_hsh[ary[0]] = {
            spreadsheetId: spreadsheetId_str,
            sheet: ary[0],
            range_start: ary[1],
            range_end: ary[2]
          }
        end
        tab_hsh
      end

      def collect_ranges_from_tabs(ref_hsh)
        range_hsh = Hash.new
        ref_hsh.each { |k, hsh| range_hsh[k] = get_values_from_spreadsheet(hsh).values }
        range_hsh
      end

      def create_reference_hash_array(spreadsheetId_str)
        header_arg_hsh = {
          spreadsheetId: spreadsheetId_str,
          sheet: 'reference',
          range_start: 'A1',
          range_end: 'F1'
        }
        header_ary_ary = get_values_from_spreadsheet(header_arg_hsh).values.flatten

        row_arg_hsh = {
          spreadsheetId: spreadsheetId_str,
          sheet: 'reference',
          range_start: 'A2',
          range_end: 'F100'
        }
        row_ary = get_values_from_spreadsheet(row_arg_hsh).values.reject {|ary| ary.empty?}

        ref_hsh_ary = Array.new

        row_ary.each do |row|
          ref_hsh_ary << {
            document: row[0],
            spreadsheetId: row[1],
            sheet: row[2],
            range_start: row[3],
            range_end: row[4],
            target_table: row[5],
            headers: header_ary_ary
          }
        end

        ref_hsh_ary
      end

      def collect_ranges_from_ref_hsh_ary(ref_hsh_ary)
        collected_range_ary = Array.new
        ref_hsh_ary.each do |ref_hsh|
          range_ary_ary = get_values_from_spreadsheet(ref_hsh).values
          collected_range_ary << [ref_hsh, range_ary_ary]
        end
        binding.pry
        collected_range_ary
      end

      def collect_ranges_from_reference_sheet(spreadsheetId_str)
        ref_hsh_ary = create_reference_hash_array(spreadsheetId_str)
        ranges = collect_ranges_from_ref_hsh_ary(ref_hsh_ary)
      end

    end
  end
end
