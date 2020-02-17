module Cpc
  module Study
    class BlockToProc
      def debug_only(param = nil, &block)
        param_class = param.class
        block_class = block.class if block_given?

        puts "param_class: #{param_class}"
        puts "block_class: #{block_class}"

        { param_class: param_class, block_class: block_class }
      end
    end
  end
end
