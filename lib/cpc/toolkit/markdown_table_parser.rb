# frozen_string_literal: true

module Cpc
  module Toolkit
    class MarkdownTableParser
      def initialize(md_path)
        @table = File.readlines(md_path)
      end

      def line_to_array(line)
        line.split('|').reject { |w| w.presence.nil? }.map(&:strip)
      end

      def table_headers
        line_to_array(@table.first).map(&:to_sym)
      end

      def table_body
        @table[2..-1].map { |line| line_to_array(line) }
      end

      def table_hash_array
        hsh_ary = []
        table_body.map do |line|
          hsh = {}
          line.each_with_index do |n, i|
            key = table_headers[i]
            value = table_value(n)
            hsh[key] = value
          end
          hsh_ary << hsh
        end
        hsh_ary
      end

      def table_value(value)
        if value.scan(/\d+/).empty?
          value
        else
          value.to_i
       end
      end
    end
  end
end
