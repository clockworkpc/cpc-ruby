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
      { spreadsheet_name: 'WidgetsRUs', spreadsheetId: '13Uk4GgmAJT9hPevM6kR_THayEIpWUznpl6twqpg2U5Y', sheet: 'customers_usa', range_start: 'A20', range_end: 'F30', :headers=>"id|christian_name|surname|email|sex|ip_address" },
      { spreadsheet_name: 'WidgetsRUs', spreadsheetId: '13Uk4GgmAJT9hPevM6kR_THayEIpWUznpl6twqpg2U5Y', sheet: 'customers_au', range_start: 'A25', range_end: 'F35', :headers=>"id|christian_name|surname|email|sex|ip_address" },
      { spreadsheet_name: 'FooBar Pty Ltd', spreadsheetId: '1_EPb9HNuf34uAFZKc1r0ieTV78JRpLd4BCk0mQXKkv8', sheet: 'customers_uk', range_start: 'A30', range_end: 'F40', :headers=>"id|christian_name|surname|email|sex|ip_address" },
      { spreadsheet_name: 'FooBar Pty Ltd', spreadsheetId: '1_EPb9HNuf34uAFZKc1r0ieTV78JRpLd4BCk0mQXKkv8', sheet: 'customers_za', range_start: 'A35', range_end: 'F45', :headers=>"id|christian_name|surname|email|sex|ip_address" }
    ]
  end

  let(:collected_ranges_json) { File.read('spec/fixtures/mock_data/collected_ranges.json') }

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
          range_end: 'F1000'
        }

        args_hsh_ary = subject.create_reference_hash_array(args_hsh)
        expect(args_hsh_ary).to eq(master_document_args_hsh_ary)
      end

      it 'should collect ranges specified by reference Hash Array' do
        args_hsh = {
          spreadsheetId: extract_spreadsheetId(master_document_url),
          sheet: 'customer_records',
          range_start: 'A1',
          range_end: 'F1000'
        }

        ref_hsh_ary = subject.create_reference_hash_array(args_hsh)
        range_hsh_ary = subject.collect_ranges_from_ref_hsh_ary(ref_hsh_ary)
        json = JSON.pretty_generate(range_hsh_ary)
        expect(JSON.parse(json)).to eq(JSON.parse(collected_ranges_json))
      end
    end

  end
end
