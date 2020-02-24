require 'spec_helper'
# require 'parameterize'

RSpec.describe Cpc::Util::StringUtil do
  include Cpc::Util::StringUtil

  let(:snake) { 'this_is_a_string' }
  let(:pascal) { 'ThisIsAString' }
  let(:camel) { 'thisIsAString' }
  let(:kebab) { 'this-is-a-string' }
  let(:downcase) { 'this is a string' }
  let(:upcase) { 'THIS IS A STRING' }
  let(:capitalized) { "This is a string" }
  let(:title) { "This Is A String" }

  let(:sql_params_hsh) do
    {
      column_name_one: 'email',
      column_name_two: 'username',
      column_name_three: 'customer_id',
      column_name_four: 'location',
      schema_name: 'my_database',
      table_name: 'customers',
    }
  end

  let(:sql_template_path) { 'spec/fixtures/util/sql_template.sql' }
  let(:sql_template_populated_path) { 'spec/fixtures/util/sql_template_populated.sql' }
  let(:sql_query_output_path) { 'spec/output/sql_template_updated.sql' }

  let(:html1) { File.read('spec/fixtures/httpbin/html_1.html') }
  let(:html2) { File.read('spec/fixtures/httpbin/html_2.html') }

  let(:httpbin_uuid) { "231ef694-c0bc-4ac9-b9b1-58ea0c663c06"}

  context 'Main tests', offline: true do
    it "should generate a sql query string from a template with parameters" do
      sql_req_str = mysql_query(sql_template_path, sql_params_hsh)
      sql_template_populated = File.read(sql_template_populated_path)

      f = File.open(sql_query_output_path, 'w')
      f.write(sql_req_str)
      f.close

      expect(sql_req_str).to eq(sql_template_populated)
    end

    it 'should convert camelCase to snake_case' do
      expect(camel_to_snake(camel)).to eq(snake)
    end

    it "should convert PascalCase to snake_case" do
      expect(pascal_to_snake(pascal)).to eq(snake)
    end

    it 'should identify whether a string is snake_case' do
      expect(snake_case?(snake)).to eq(true)
      expect(snake_case?(pascal)).to eq(false)
      expect(snake_case?(camel)).to eq(false)
      expect(snake_case?(kebab)).to eq(false)
      expect(snake_case?('THIS_IS_A_STRING')).to eq(false)
    end

    it 'should identify whether a string is kebab-case' do
      expect(kebab_case?(snake)).to eq(false)
      expect(kebab_case?(pascal)).to eq(false)
      expect(kebab_case?(camel)).to eq(false)
      expect(kebab_case?(kebab)).to eq(true)
      expect(kebab_case?('THIS_IS_A_STRING')).to eq(false)
    end

    it 'should identify whether a string is camelCase' do
      expect(camel_case?(snake)).to eq(false)
      expect(camel_case?(pascal)).to eq(false)
      expect(camel_case?(camel)).to eq(true)
      expect(camel_case?(kebab)).to eq(false)
      expect(camel_case?('THIS_IS_A_STRING')).to eq(false)
    end

    it 'should identify whether a string is PascalCase' do
      expect(pascal_case?(snake)).to eq(false)
      expect(pascal_case?(pascal)).to eq(true)
      expect(pascal_case?(camel)).to eq(false)
      expect(pascal_case?(kebab)).to eq(false)
      expect(pascal_case?('THIS_IS_A_STRING')).to eq(false)
    end

    it 'should parameterize a string' do
      expect(Cpc::Util::StringUtil.parameterize('Hello, World')).to eq(:hello_world)
      expect(Cpc::Util::StringUtil.parameterize('Hello World')).to eq(:hello_world)
      expect(Cpc::Util::StringUtil.parameterize('Hello-World')).to eq(:hello_world)
      expect(Cpc::Util::StringUtil.parameterize('Hello_World')).to eq(:hello_world)
      expect(Cpc::Util::StringUtil.parameterize('Accept-Encoding')).to eq(:accept_encoding)
      expect(Cpc::Util::StringUtil.parameterize('Hello_World-World World')).to eq(:hello_world_world_world)
    end

    it 'should check whether two texts are the same' do
      expect(text_no_diff?(html1, html2)).to eq(true)
    end

    it 'should check whether the text is html' do
      expect(html?(File.read('spec/fixtures/httpbin/html.html'))).to eq(true)
    end

    it 'should check whether the text is xml' do
      expect(xml?(File.read('spec/fixtures/httpbin/xml_body.xml'))).to eq(true)

    end
  end
end
