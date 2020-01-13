# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Util::GenerateDataUtil do
  include Cpc::Util::GenerateDataUtil
  include Cpc::Util::FileParseUtil

  let(:hsh) { { hello: 'world', greetings: 'earth', salutations: 'planet' } }
  let(:ary_hsh_path) { 'spec/fixtures/util/json_for_csv.json' }
  let(:prettified_json_path) { 'spec/output/prettified_json.json' }
  let(:csv_with_headers_path) { 'spec/output/csv_with_headers.csv' }
  let(:isbn_csv_with_headers_path) { 'spec/output/isbn_csv_with_headers.csv' }

  let(:isbn_hsh) do
    { response_code: '200',
      isbn: '9781931499651',
      long_title: 'Knitting Vintage Socks',
      author: 'Nancy Bush',
      publisher: 'Interweave',
      binding: 'Spiral-bound',
      pages: 128,
      date_published: '2005' }
  end

  context 'Main tests', offline: true do
    it 'should generate prettified JSON from a Hash' do
      prettified_json = prettified_json_from_hash(hsh)

      f = File.open(prettified_json_path, 'w')
      f.write(prettified_json)
      f.close

      expect(valid_json?(prettified_json_path)).to eq(true)
    end

    it 'should generate CSV from an ISBN Hash' do
      ary_hsh = parse_json_file(ary_hsh_path)
      csv = csv_from_hash(ary_hsh)

      f = File.open(isbn_csv_with_headers_path, 'w')
      f.write(csv)
      f.close

      expect(parse_csv_file(csv_with_headers_path)).to be_a(CSV::Table)
    end
  end
end
