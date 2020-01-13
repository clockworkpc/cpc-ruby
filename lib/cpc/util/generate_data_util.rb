require 'csv'

module Cpc
  module Util
    module GenerateDataUtil
      def prettified_json_from_hash(hsh)
        JSON.pretty_generate(hsh)
      end

      def csv_from_simple_hsh_sans_header(hsh)
        CSV.generate { |csv| csv << hsh.values }
      end

      def csv_from_simple_hsh_with_header(hsh)
        header_str_ary = hsh.keys
        my_csv = CSV.generate(headers: true, converters: :numeric) do |csv|
          csv << header_str_ary
          csv << hsh.values
        end
        my_csv
      end

      def csv_from_hash(ary_hsh)
        header_str_ary = ary_hsh.keys
        my_csv = CSV.generate(headers: true, converters: :numeric) do |csv|
          csv << header_str_ary
          ary_hsh.values.each do |ary|
            csv << ary
          end
        end
        my_csv
      end

      def csv_from_sql(sql)
        header_str_ary = sql.columns
        my_csv = CSV.generate(headers: true, converters: :numeric) do |csv|
          csv << header_str_ary
          sql.to_a.each do |hash|
            csv << hash.values
          end
        end
        my_csv
      end
    end
  end
end
