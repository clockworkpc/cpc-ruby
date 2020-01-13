require 'spec_helper'

RSpec.describe Cpc do
  include Cpc::Util::CollectionUtil
  let(:json_file_path) { 'spec/fixtures/util/sample.json' }
  let(:hsh_ary_hsh) { {a: [{ a1: "hello", a2: "world" }, { a3: "hello", a4: "world" }], b: [{ b1: "hello", b2: "world" }, { b3: "hello", b4: "world" }]} }
  let(:hsh_ary) { [{ a: "hello", b: "world" }, { a: "hello", b: "world" }] }
  let(:ary_ary) { [%w[this is an array], %w[this is an array]] }
  let(:hsh) { { a: "hello", b: "world" } }
  let(:ary) { %w[this is an array] }
  let(:sym) { :symbol }
  let(:int) { 123 }
  let(:f2) { 123.12 }

  context 'Basic tests', offline: true do
    it "has a version number" do
      expect(Cpc::VERSION).not_to be nil
    end

    it "does something useful" do
      expect(false).to eq(false)
    end

    it 'does something useful again' do
      expect(2 + 2).to eq(4)
    end

    it "should receive a method from an included module" do
      expect(hello_classifier).to eq('hello_classifier')
    end

    it 'offline example', offline: true do
      hello_offline = 'hello_offline'
      expect(hello_offline).to eq('hello_offline')
    end
  end
end
