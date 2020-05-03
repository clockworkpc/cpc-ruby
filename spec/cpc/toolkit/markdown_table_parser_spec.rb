# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Toolkit::MarkdownTableParser do
  let(:table_headers) { %i[model prefix verb format code] }

  let(:table_body) do
    [
      %w[organisation organisations GET JSON 401],
      %w[organisation organisations POST JSON 401],
      %w[collection responses_collection GET JSON 401],
      %w[collection organisation_collections GET JSON 401],
      %w[response responses_create POST JSON 201]
    ]
  end

  let(:table_hsh_ary) do
    [
      { model: 'organisation', prefix: 'organisations', verb: 'GET', format: 'JSON', code: 401 },
      { model: 'organisation', prefix: 'organisations', verb: 'POST', format: 'JSON', code: 401 },
      { model: 'collection', prefix: 'responses_collection', verb: 'GET', format: 'JSON', code: 401 },
      { model: 'collection', prefix: 'organisation_collections', verb: 'GET', format: 'JSON', code: 401 },
      { model: 'response', prefix: 'responses_create', verb: 'POST', format: 'JSON', code: 201 }
    ]
  end

  context 'Scenarios Table', offline: true do
    before(:all) do
      scenarios_table_path = 'spec/fixtures/markdown_table_parser/scenarios.md'
      @subject = Cpc::Toolkit::MarkdownTableParser.new(scenarios_table_path)
    end

    it 'should read the table headers' do
      expect(@subject.table_headers).to eq(table_headers)
    end

    it 'should read the table body ' do
      expect(@subject.table_body).to eq(table_body)
    end

    it 'should return JSON of table' do
      expect(@subject.table_hash_array).to eq(table_hsh_ary)
    end
  end
end
