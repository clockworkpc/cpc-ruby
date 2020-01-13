require 'facets/string/titlecase'
require 'cpc/util/string_util'

module Cpc
  module Util
    module CaseUtil
      include Util
      include StringUtil
      def hello_case_util
        "hello_case_util"
      end

      def kebab_to_snake(str)
        split_join(str, '-', '_')
      end

      def downcase_to_snake(str)
        split_join(str, nil, '_')
      end

      def upcase_to_snake(str)
        split_join(str.downcase, nil, '_')
      end

      def capitalized_to_snake(str)
        upcase_to_snake(str)
      end

      def title_to_snake(str)
        upcase_to_snake(str)
      end

      def pascal_to_title(str)
        snake_str = camel_to_snake(str).sub('_', '')
        downcase_str_ary = snake_str.split('_')
        downcase_str_ary.map { |s| s.titlecase }.join(' ')
      end
    end
  end
end
