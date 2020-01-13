require_relative '../util/pleasing_print_util'
# require_relative '../util/collection_util'

module Cpc
  module Codewars
    module DryingPotatoes
      include Cpc::Util::PleasingPrintUtil
      include Codewars

      def potatoes(p0, w0, p1)
        weight_percent_water_pre = (p0 * 0.01).round(2)
        weight_total_pre = w0
        weight_percent_water_post = (p1 * 0.01).round(2)
        weight_percent_dry_post = (1 - weight_percent_water_post).round(2)
        wet_weight_pre = (weight_total_pre * weight_percent_water_pre).round(2)
        dry_weight = (weight_total_pre - wet_weight_pre)
        wet_weight_post = ((weight_percent_water_post * dry_weight) / weight_percent_dry_post)
        weight_total_post = (dry_weight + wet_weight_post)

        # workings_hsh = {
        #   weight_total_pre: weight_total_pre,
        #   weight_percent_water_pre: weight_percent_water_pre,
        #   weight_percent_water_post: weight_percent_water_post,
        #   weight_percent_dry_post: weight_percent_dry_post,
        #   wet_weight_pre: wet_weight_pre,
        #   dry_weight: dry_weight,
        #   wet_weight_post: wet_weight_post,
        #   weight_total_post: weight_total_post,
        #   weight_total_post_rounded: weight_total_post.round(2).to_i
        # }

        # puts "\nWORKINGS\n\n"
        # pleasing_print_hash(workings_hsh)
        weight_total_post.round(2).to_i
      end

      def alt_potatoes(initial_water_percentage, total_weight, final_water_percentage)
        water_weight = total_weight * initial_water_percentage / 100.0
        potato_weight = total_weight - water_weight
        final_weight = potato_weight / (1 - final_water_percentage / 100.0)
        final_weight.round(2).to_i

        {
          water_weight: water_weight,
          potato_weight: potato_weight,
          final_weight: final_weight,
          final_weight_rounded: final_weight.round(2).to_i
        }
      end
    end
  end
end
