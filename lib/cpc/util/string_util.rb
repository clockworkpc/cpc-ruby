module Cpc
  module Util
    module StringUtil
      include Util
      def hello_string_util
        'hello_string_util'
      end

      def mysql_query(sql_template_path, sql_params_hsh)
        sql_template_txt = File.read(sql_template_path)
        sql_params_hsh.each { |k, v| sql_template_txt.gsub!(k.to_s.upcase, v) }
        sql_template_txt
      end

      def camel_to_snake(str)
        str.gsub(/[A-Z]/) { |s| [ "_", s.downcase].join }
      end

      def pascal_to_snake(str)
        camel_to_snake(str).sub('_', '')
      end

      def match_scan_split(str, delimiter_str, case_str = 'downcase')
        scan = str.scan(/[a-z]/).join if case_str == 'downcase'
        scan = str.scan(/[A-Z]/).join if case_str == 'upcase'
        split = str.split(delimiter_str).join
        scan == split
      end

      def snake_case?(str)
        match_scan_split(str, '_')
      end

      def kebab_case?(str)
        match_scan_split(str, '-')
      end

      def camel_case?(str)
        not_camel_case = snake_case?(str) || str[0] != str[0].downcase
        not_camel_case ? false : snake_case?(camel_to_snake(str))
      end

      def pascal_case?(str)
        downcase_ary = str.split('').select {|s| s.match?(/[a-z]/)}
        upcase_ary = str.split('').select {|s| s.match?(/[A-Z]/)}

        has_downcase = downcase_ary.positive?
        has_upcase = upcase_ary.positive?
        mixed_case = has_downcase && has_upcase

        split_ary = str.gsub(/[A-Z]/) { |s| [ ' ', s].join }.split
        pascal_check_ary = split_ary.map { |s| s.match?(/[A-Z][a-z]*/) }.uniq
        pascal_check = pascal_check_ary.count == 1 && pascal_check_ary.first == true

        mixed_case ? pascal_check : false
      end

      def self.parameterize(input)
        str = input.to_s.downcase
        delimiters = [' ', '-', '_', ',', ';']
        delimiters.each { |d| str = str.split(d).join('_') }
        str.split('_').reject(&:empty?).join('_').to_sym
      end
      
      def self.convert_to_file_basename(input)
        str = input.to_s.downcase
        delimiters = [' ', '-', '_', ',', ';']
        delimiters.each { |d| str = str.split(d).join('_') }
        b = str.split('_').reject(&:empty?).join('_')
        b.gsub(/\W/, '')
      end

      def text_diff(str1, str2)
        diff_ary = []
        str1_ary = str1.split("\n")
        str2_ary = str2.split("\n")
        str1_ary.each_with_index { |n, i| diff_ary << [n, str2_ary[i]] unless n.strip.eql?(str2_ary[i].strip) }
        diff_ary
      end

      def text_no_diff?(str1, str2)
        text_diff(str1, str2).empty?
      end

      def html?(str)
        str.split("\n").first.match?("<!DOCTYPE html>")
      end

      def xml?(str)
        str.split("\n").first.match?(/<\?xml\s.+\?>/)
      end

      def something; end

    end
  end
end
