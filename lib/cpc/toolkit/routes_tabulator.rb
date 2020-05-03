# frozen_string_literal: true

module Cpc
  module Toolkit
    class RoutesTabulator
      def initialize(routes_table_txt)
        @routes_table = File.readlines(routes_table_txt)
      end

      def serialize_table
        latest_url_helper = nil
        route_ary = @routes_table.map(&:split)
        require 'pry'; binding.pry
      end
    end
  end
end
