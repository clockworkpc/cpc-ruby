module Cpc
  module Codewars
    module Order
      def word_number(str)
        str.scan(/[1-9]/).first.to_i
      end

      def order(str)
        ordered_ary = []
        word_ary = str.split
        number_ary = word_ary.map { |w| word_number(w) }.sort
        number_ary.each do |n|
          word_ary.each do |w|
            ordered_ary << w if w.match?(n.to_s)
          end
        end
        ordered_ary.join(' ')
      end

      def alt_order(words)
        words.split.sort_by{ |w| w[/\d/] }.join(' ')
      end
    end
  end
end
