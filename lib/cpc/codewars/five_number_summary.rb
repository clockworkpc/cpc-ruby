module Cpc
  module Codewars
    module FiveNumberSummary
      def median_value(ary)
        median_fr2 = ary[(ary.length - 1) * 0.5]
        median_next_fr2 = ary[ary.length * 0.5]
        (median_fr2 + median_next_fr2) * 0.5
      end

      def lower_values(ary)
        q2 = median_value(ary)
        ary.select { |n| n <= q2 }
      end

      def upper_values(ary)
        q2 = median_value(ary)
        ary.select { |n| n >= q2 }
      end

      def five_num(ary)
        output_ary = []

        ary = ary.sort.map {|n| n.to_f.round(2)}
        min_fr2 = ary.min.to_f.round(1)
        max_fr2 = ary.max.to_f.round(1)
        q2_fr2 = median_value(ary)
        q1_fr2 = median_value(lower_values(ary))
        q3_fr2 = median_value(upper_values(ary))

        output_ary << min_fr2
        output_ary << q1_fr2
        output_ary << q2_fr2
        output_ary << q3_fr2
        output_ary << max_fr2

        output_ary.flatten
      end

    end
  end
end
