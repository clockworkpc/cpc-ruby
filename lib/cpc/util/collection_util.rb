# frozen_string_literal: true

require  'active_support/core_ext/hash'
require_relative 'string_util'

module Cpc
  module Util
    module CollectionUtil
      include Cpc::Util::StringUtil

      def hello_classifier
        'hello_classifier'
      end

      def array?(obj)
        obj.class == Array
      end

      def hash?(obj)
        obj.class == Hash
      end

      def nested_hash?(obj)
        is_nested_hash = false
        if hash?(obj)
          hash_values = obj.values.select { |v| v.is_a?(Hash) }
          is_nested_hash = true unless hash_values.empty?
        end
        is_nested_hash
      end

      def composed_of_hashes?(obj)
        m = obj.map { |n| hash?(n) }.uniq
        m.count == 1 && m.first == true
      end

      def composed_of_arrays?(obj)
        m = obj.map { |n| array?(n) }.uniq
        m.count == 1 && m.first == true
      end

      def hash_array?(obj)
        array?(obj) ? composed_of_hashes?(obj) : false
      end

      def array_array?(obj)
        array?(obj) ? composed_of_arrays?(obj) : false
      end

      def hash_array_hash?(obj)
        value_check_ary = []

        if hash?(obj)
          obj.map do |_k, v|
            if array?(v)
              value_check = v.map { |_n| composed_of_hashes?(v) }
              value_check_ary << value_check
            end
          end
        end

        tidied_check = value_check_ary.flatten.uniq
        tidied_check.count == 1 && tidied_check.first == true
      end

      def classify(obj)
        if hash_array_hash?(obj)
          'hash_array_hash'
        elsif hash_array?(obj)
          'hash_array'
        elsif array_array?(obj)
          'array_array'
        else
          obj.class.to_s.downcase
        end
      end

      def hash_depth(hsh)
        depth = 0
        unless hsh.class != Hash
          values = hsh.values
          arr = values
          loop do
            arr = arr.flatten.select { |e| e.is_a? Hash }
            break depth if arr.empty?

            depth += 1
            arr = arr.map(&:values)
            # puts "depth = #{depth}, arr = #{arr}"
          end
        end
        depth
      end

      def map_value(thing)
        case thing
        when Hash
          symbolize_recursive(thing)
        when Array
          thing.map { |v| map_value(v) }
        else
          thing
        end
      end

      def symbolize_recursive(hash)
        {}.tap do |h|
          hash.each { |key, value| h[parameterize(key)] = map_value(value) }
        end
      end

      def symbolize_keys(hsh)
        sym_hsh = {}

        unless !hsh.is_a?(Hash)
          depth = hash_depth(hsh)
          sym_hsh = hsh.transform_keys { |k| parameterize(k) } if depth == 0
          sym_hsh = symbolize_recursive(hsh) if depth > 0
        else
          raise "Not a Hash: #{hsh.class}"
        end

        sym_hsh
      end

      def valid_json?(json)
        begin
          JSON.parse(json)
          return true
        rescue JSON::ParserError
          return false
        end
      end

      def convert_nested_array_to_hash_array(key_ary, ary_ary)
        hsh_ary = []
        ary_ary.each do |v|
          hsh = Hash.new
          key_ary.each_with_index { |k, i| hsh[k] = v[i] }
          hsh_ary << hsh
        end
        hsh_ary
      end
    end
  end
end
