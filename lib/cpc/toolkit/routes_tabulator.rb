# frozen_string_literal: true

module Cpc
  module Toolkit
    class RoutesTabulator
      def initialize(routes_table_txt)
        @routes_table = File.readlines(routes_table_txt)
      end

      ROUTE_HEADERS = %i[prefix verb uri_pattern controller action].freeze
      HTTP_VERBS = %w[GET POST PUT PATCH DELETE].freeze

      def controller_action(str)
        split = str.split('#')
        [split.first, split.last]
      end

      def format(str)
        require 'pry'; binding.pry unless str.nil?
        eval str
      end

      def named_path_row(ary)
        hsh = {}
        hsh[:prefix] = ary[0]
        hsh[:verb] = ary[1]
        hsh[:uri_pattern] =  ary[2]
        controller, action = controller_action(ary[3])
        hsh[:controller] = controller
        hsh[:action] = action
        hsh[:format] = eval(ary[4])[:format] unless ary[4].nil?
        hsh
      end

      def unnamed_path_row(ary)
        hsh = {}
        hsh[:prefix] = nil
        hsh[:verb] = ary[0]
        hsh[:uri_pattern] =  ary[1]
        controller, action = controller_action(ary[2])
        hsh[:controller] = controller
        hsh[:action] = action
        hsh[:format] = eval(ary[3])[:format] unless ary[3].nil?
        hsh
      end

      def row_hash(ary)
        named_path = !HTTP_VERBS.include?(ary[0])
        named_path ? named_path_row(ary) : unnamed_path_row(ary)
      end

      def serialize_table
        table_hsh_ary = []
        latest_url_helper = nil
        route_ary_ary = @routes_table.map(&:split)

        route_ary_ary.each_with_index do |route_ary, i|
          next if i == 0

          table_hsh_ary << row_hash(route_ary)
        end

        table_hsh_ary

        require 'pry'; binding.pry
      end
    end
  end
end
