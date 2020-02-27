module Cpc
  module Study
    class Spaceship
      attr_reader :debug_attrs

      def initialize
        @debug = true
        @debug_attrs = { containment_status: :ok, core_temp: 350 }
      end

      def debug_only
        return nil unless @debug
        return nil unless block_given?
        puts "Running debug code..."
        yield @debug_attrs
      end

      def locate_cargo
        attrs = {weight: 10, destination: "Earth"}
        cargo_accessed = debug_only { |attrs| attrs[:cargo_accessed] = true }
        { attrs: attrs, cargo_accessed: cargo_accessed }
      end

      def locate_cargo_with_shadowed_attrs_hsh
        attrs = {weight: 10, destination: "Earth"}
        cargo_accessed = debug_only do |d_attrs; attrs|
          attrs = {}
      end
        { attrs: attrs, cargo_accessed: cargo_accessed }
      end
    end
  end
end
