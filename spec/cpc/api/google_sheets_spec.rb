# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Api::GoogleSheets do
  include Cpc::Util::FileParseUtil
  include Cpc::Util::GoogleUtil

  let(:mock_data_01) { parse_csv_file('spec/fixtures/mock_data/mock_data_01.csv') }
  let(:mock_data_02) { parse_csv_file('spec/fixtures/mock_data/mock_data_02.csv') }
  let(:mock_data_03) { parse_csv_file('spec/fixtures/mock_data/mock_data_03.csv') }
  let(:mock_data_04) { parse_csv_file('spec/fixtures/mock_data/mock_data_04.csv') }

  let(:widgets_spreadsheetId) { '13Uk4GgmAJT9hPevM6kR_THayEIpWUznpl6twqpg2U5Y' }
  let(:foobar_spreadsheetId) { '1_EPb9HNuf34uAFZKc1r0ieTV78JRpLd4BCk0mQXKkv8' }
  let(:master_document_url) { 'https://docs.google.com/spreadsheets/d/1OqTAwkCdU50hG1SdFGOgoRssZeR2qqviAERYtrf0TfE/edit#gid=0' }

  let(:master_document_args_hsh_ary) do
    [
      { spreadsheetName: 'WidgetsRUs', spreadsheetId: '13Uk4GgmAJT9hPevM6kR_THayEIpWUznpl6twqpg2U5Y', sheetName: 'customers_usa', rangeStart: 'A20', rangeEnd: 'F30' },
      { spreadsheetName: 'WidgetsRUs', spreadsheetId: '13Uk4GgmAJT9hPevM6kR_THayEIpWUznpl6twqpg2U5Y', sheetName: 'customers_au', rangeStart: 'A25', rangeEnd: 'F35' },
      { spreadsheetName: 'FooBar Pty Ltd', spreadsheetId: '1_EPb9HNuf34uAFZKc1r0ieTV78JRpLd4BCk0mQXKkv8', sheetName: 'customers_uk', rangeStart: 'A30', rangeEnd: 'F40' },
      { spreadsheetName: 'FooBar Pty Ltd', spreadsheetId: '1_EPb9HNuf34uAFZKc1r0ieTV78JRpLd4BCk0mQXKkv8', sheetName: 'customers_za', rangeStart: 'A35', rangeEnd: 'F45' }
    ]
  end

  context 'Mock Data', online: true do
    subject = Cpc::Api::GoogleSheets.new('clockworkpc')
    context 'Widgets R Us', online: false do
      it 'should return a JSON object from customers_usa' do
        args_hsh = {
          spreadsheetId: widgets_spreadsheetId,
          sheet: 'customers_usa',
          range_start: 'A1',
          range_end: '101'
        }

        res = subject.get_values_from_spreadsheet(args_hsh)
        expect(res.values[50][1]).to eq(mock_data_01[49][:christian_name])
        expect(res.values[50][2]).to eq(mock_data_01[49][:surname])
        expect(res.values[50][3]).to eq(mock_data_01[49][:email])
        expect(res.values[50][4]).to eq(mock_data_01[49][:sex])
        expect(res.values[50][5]).to eq(mock_data_01[49][:ip_address])
      end

      it 'should return a JSON object from customers_au' do
        args_hsh = {
          spreadsheetId: widgets_spreadsheetId,
          sheet: 'customers_au',
          range_start: 'A1',
          range_end: '101'
        }

        res = subject.get_values_from_spreadsheet(args_hsh)
        expect(res.values[50][1]).to eq(mock_data_02[49][:christian_name])
        expect(res.values[50][2]).to eq(mock_data_02[49][:surname])
        expect(res.values[50][3]).to eq(mock_data_02[49][:email])
        expect(res.values[50][4]).to eq(mock_data_02[49][:sex])
        expect(res.values[50][5]).to eq(mock_data_02[49][:ip_address])
      end
    end

    context 'FooBar', online: false do
      it 'should return a JSON object from customers_uk' do
        args_hsh = {
          spreadsheetId: foobar_spreadsheetId,
          sheet: 'customers_uk',
          range_start: 'A1',
          range_end: '101'
        }

        res = subject.get_values_from_spreadsheet(args_hsh)
        expect(res.values[50][1]).to eq(mock_data_03[49][:christian_name])
        expect(res.values[50][2]).to eq(mock_data_03[49][:surname])
        expect(res.values[50][3]).to eq(mock_data_03[49][:email])
        expect(res.values[50][4]).to eq(mock_data_03[49][:sex])
        expect(res.values[50][5]).to eq(mock_data_03[49][:ip_address])
      end

      it 'should return a JSON object from customers_za' do
        args_hsh = {
          spreadsheetId: foobar_spreadsheetId,
          sheet: 'customers_za',
          range_start: 'A1',
          range_end: '101'
        }

        res = subject.get_values_from_spreadsheet(args_hsh)
        expect(res.values[50][1]).to eq(mock_data_04[49][:christian_name])
        expect(res.values[50][2]).to eq(mock_data_04[49][:surname])
        expect(res.values[50][3]).to eq(mock_data_04[49][:email])
        expect(res.values[50][4]).to eq(mock_data_04[49][:sex])
        expect(res.values[50][5]).to eq(mock_data_04[49][:ip_address])
      end
    end

    context 'Master Document' do
      it 'should return the Master Document as a Hash' do
        args_hsh = {
          spreadsheetId: extract_spreadsheetId(master_document_url),
          sheet: 'customer_records',
          range_start: 'A1',
          range_end: 'E1000'
        }

        spreadsheet = subject.get_values_from_spreadsheet(args_hsh)
        args_hsh_ary = subject.convert_spreadsheet_to_hash_array(spreadsheet)

        binding.pry
      end
    end
  end
end
