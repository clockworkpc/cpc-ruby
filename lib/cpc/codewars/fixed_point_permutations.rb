module Cpc
  module Codewars
    module FixedPointPermutations

      def haps(a_ary, b_ary)
        matches_int = 0
        a_ary.each_with_index { |n, i| matches_int += 1 if n == b_ary[i] }
        matches_int
      end



      def fixed_point_perm_collection(perm_ary, haps_int)
        special_perm_ary = []

        perm_ary.each do |perm|
          selected_perm = perm_ary.shift
          perm_ary.each_with_index do |inner_perm, index|
            haps_check_int = haps(selected_perm, inner_perm)
            match = haps_check_int == haps_int
            if match
              puts "#{selected_perm} == #{inner_perm}"
              # special_perm_ary << selected_perm
              special_perm_ary << inner_perm
            end
            perm_ary.delete(perm_ary[index])
          end
        end

        special_perm_ary
      end

      def fixed_point_perms(length_int, haps_int)
        special_perm_ary = []
        ary = (0...length_int).to_a
        perm_ary = ary.permutation.map { |perm| perm }.sort
        original_perm = perm_ary.shift
        special_perm_ary = fixed_point_perm_collection(perm_ary, haps_int)

        # original_perm.each_with_index do |n, i|
        #   perm_ary.each do |perm|
        #     if perm[i] == n
        #       haps_check_int = haps()
        #     end
        #   end
        # end


        tidied = special_perm_ary.sort.uniq

        if length_int > haps_int
          0
        elsif length == haps_int
          1
        else
          special_perm_ary.sort.uniq.count
        end
      end
    end
  end
end
