# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Toolkit::RoutesTabulator do
  let(:routes_table_txt) { 'spec/fixtures/routes_tabulator/routes_table.txt' }
  let(:table_ary_json) { 'spec/fixtures/routes_tabulator/routes_array.json' }

  describe 'Output of "rails routes"', offline: true do
    before(:each) do
      routes_table_txt = 'spec/fixtures/routes_tabulator/routes_table.txt'
      @subject = Cpc::Toolkit::RoutesTabulator.new(routes_table_txt)
    end

    it 'should serialize the table' do
      @subject.serialize_table
      expect(@subject.serialize_table).to eq(JSON.parse(File.read(table_ary_json)))
    end

    it 'should ' do
      
    end
  end
end
