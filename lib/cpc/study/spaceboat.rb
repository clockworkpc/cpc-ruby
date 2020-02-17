module Cpc
  module Study
    class Spaceboat
      def initialize
        @debug_attrs = { containment_status: :ok, core_temp: 350 }
      end
      def launch
        debug_only { p @debug_attrs }
      end
    end
  end
end
