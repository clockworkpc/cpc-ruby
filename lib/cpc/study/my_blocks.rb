module Cpc
  module Study
    class MyBlocks
      def method_with_yield
        return nil unless block_given?
        puts "This method yields to a block"
        yield
      end

      def method_sans_yield
        return nil unless block_given?
        puts "This method yields not to a block"
      end    
    end
  end
end
