require 'spec_helper'

RSpec.describe Cpc::Util::PleasingPrintUtil do
  include Cpc::Util::CollectionUtil
  include Cpc::Util::PleasingPrintUtil

  let(:hsh_ary_hsh) { {a: [{ a1: "hello", a2: "world" }, { a3: "hello", a4: "world" }], b: [{ b1: "hello", b2: "world" }, { b3: "hello", b4: "world" }]} }
  let(:hsh_ary) { [{ a: "hello", b: "world" }, { c: "goodbye", d: "universe" }] }
  let(:ary_ary) { [%w[this is an array], %w[yet another array here]] }
  let(:hsh) { { f: "thanks", g: "for all the fish" } }
  let(:ary) { %w[this is an array] }
  let(:sym) { :symbol }
  let(:int) { 123 }
  let(:f2) { 123.12 }

  context 'Main tests', offline: true do
    it 'should print every element of Hash' do
      pleasing_print_hash(hsh)
    end

    it 'should print every element of an Array' do
      pleasing_print_array(ary)
      pleasing_print_array(hsh_ary)
    end

    it 'should print every element of a Hash-Array' do
      pleasing_print_hash_array(hsh_ary)
    end

    it 'should print every element of an Array-Array' do
      pleasing_print_array_array(ary_ary)
    end

    it 'should pleasingly print enumerable objects' do
      default_pleasing_print(hsh_ary)
      default_pleasing_print(ary_ary)
      default_pleasing_print(hsh)
      default_pleasing_print(ary)
    end
  end
end
