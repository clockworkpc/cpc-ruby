module Cpc
  module Util
    module MathsUtil
      def bigger_number(a, b)
        b > a ? b : a
      end

      def number_diff(max, min)
        ((max - min) / max.to_f)
      end
    end
  end
end
