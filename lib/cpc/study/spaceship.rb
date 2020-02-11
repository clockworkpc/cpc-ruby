module Cpc
  module Study
    class Spaceship
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
        debug_only { |attrs| attrs[:cargo_accessed] = true }
        attrs, @debug_attrs

      end
    end
  end
end
