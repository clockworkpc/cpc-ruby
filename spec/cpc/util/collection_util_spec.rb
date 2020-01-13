require 'spec_helper'

RSpec.describe Cpc::Util::CollectionUtil do
  include Cpc::Util::CollectionUtil

  let(:hsh_ary_hsh) { {a: [{ a1: "hello", a2: "world" }, { a3: "hello", a4: "world" }], b: [{ b1: "hello", b2: "world" }, { b3: "hello", b4: "world" }]} }
  let(:hsh_ary) { [{ a: "hello", b: "world" }, { a: "hello", b: "world" }] }
  let(:ary_ary) { [%w[this is an array], %w[this is an array]] }
  let(:hsh) { { a: "hello", b: "world" } }
  let(:ary) { %w[this is an array] }
  let(:sym) { :symbol }
  let(:int) { 123 }
  let(:f2) { 123.12 }

  let(:hsh0) { JSON.parse({ "hello": 'world' }.to_json) }
  let(:hsh0_sym) { { hello: 'world' } }

  let(:hsh1_json) do
    JSON.parse(hsh1_sym.to_json)
  end

  let(:hsh1_sym) do
    {
      foo: 'bar',
      foo0: {
        foo1: 'bar1'
      },
      foo_string: 'string'
    }
  end

  let(:hsh2_json) { JSON.parse(hsh2_sym.to_json) }

  let(:hsh2_sym) do
    {
      foo0a: 'bar0a',
      foo0b: {
        foo1a: 'bar1a'
      },
      foo0c: {
        foo1b: 'bar1b',
        foo1c: {
          foo2a: 'bar2a'
        }
      }
    }
  end

  let(:nested_hsh) do
    {
      foo0a: {
        foo1a: 'bar1a'
      },
      foo0b: 'bar0b'
    }
  end

  context 'Main Tests', offline: true do
    it 'returns hello_classifier' do
      expect(hello_classifier).to eq('hello_classifier')
    end

    it 'should return an Array check' do
      expect(array?(ary)).to eq(true)
      expect(array?(hsh)).to eq(false)
    end

    it 'should return a Hash check' do
      expect(hash?(ary)).to eq(false)
      expect(hash?(hsh)).to eq(true)
    end

    it 'should return a Hash-Array' do
      expect(hash_array?(ary)).to eq(false)
      expect(hash_array?(hsh)).to eq(false)
      expect(hash_array?(hsh_ary)).to eq(true)
    end

    it 'should return a Array-Array' do
      expect(array_array?(ary)).to eq(false)
      expect(array_array?(hsh)).to eq(false)
      expect(array_array?(ary_ary)).to eq(true)
    end

    it 'should return a Hash-Array-Hash' do
      expect(hash_array_hash?(hsh_ary_hsh)).to eq(true)
      expect(hash_array_hash?(hsh_ary)).to eq(false)
    end

    it 'should classify by object type' do
      expect(classify(hsh_ary_hsh)).to eq('hash_array_hash')
      expect(classify(hsh_ary)).to eq('hash_array')
      expect(classify(ary_ary)).to eq('array_array')
      expect(classify(ary)).to eq('array')
      expect(classify(hsh)).to eq('hash')
      expect(classify(sym)).to eq('symbol')
      expect(classify(int)).to eq('integer')
      expect(classify(f2)).to eq('float')
    end

    it 'should return depth of Hash' do
      expect(hash_depth(hsh0)).to eq(0)
      expect(hash_depth(hsh1_json)).to eq(1)
    end

    it 'should return whether nested_hash' do
      expect(nested_hash?(nested_hsh)).to eq(true)
      expect(nested_hash?(hsh0)).to eq(false)
    end

    it 'should convert nested keys to symbols' do
      expect(symbolize_keys(hsh0)).to eq(hsh0_sym)
      expect(symbolize_keys(hsh1_json)).to eq(hsh1_sym)
      expect(symbolize_keys(hsh2_json)).to eq(hsh2_sym)
      expect {symbolize_keys('hash')}.to raise_error(RuntimeError, "Not a Hash: #{'hash'.class}")
    end
  end
end
