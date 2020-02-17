module Cpc
  module Study
    class BlockToProc
      def debug_only(param = nil, &block)
        param_class = param.class
        block_class = block.class if block_given?

        { param_class: param_class, block_class: block_class }
      end

      def my_proc
        Proc.new { |x| x }
      end

      def basic_lambda
        lambda { |x| x }
      end

      def stabby_lambda

      end
    end
  end
end
