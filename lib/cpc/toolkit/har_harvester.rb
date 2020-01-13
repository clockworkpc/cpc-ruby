require_relative '../util/file_parse_util'
require_relative '../util/collection_util'

module Cpc
  module Toolkit
    class HarHarvester
      include Cpc::Util::FileParseUtil
      include Cpc::Util::CollectionUtil

      def log(har_path)
        parse_har_file(har_path)[:log]
      end

      def pages(har_path)
        log(har_path)[:pages]
      end

      def entries(har_path)
        log(har_path)[:entries]
      end

      def requests(har_path)
        entries(har_path).map { |entry_hsh| entry_hsh[:request] }
      end

      def request_by_file_type(req_hsh_ary, file_type_str)
        suffix_str = ['.', file_type_str].join
        req_hsh_ary.select {|req_hsh| req_hsh[:url].match(suffix_str)}
      end

      def json_html_requests(req_hsh_ary)
        json_req_hsh_ary = request_by_file_type(req_hsh_ary, 'json')
        html_req_hsh_ary = request_by_file_type(req_hsh_ary, 'html')
        ([json_req_hsh_ary] + [html_req_hsh_ary]).flatten
      end

      def extract_essential_request_data(req_hsh_ary)
        essential_req_hsh_ary = []

        req_hsh_ary.each do |req_hsh|
          essential_req_hsh = {}
          method_str = req_hsh[:method]
          url_str = tidy_up(req_hsh[:url])
          postData_str = req_hsh[:postData] unless req_hsh[:postData].nil?

          essential_req_hsh[:method] = method_str
          essential_req_hsh[:url] = url_str
          essential_req_hsh[:postData] = postData_str unless req_hsh[:postData].nil?

          essential_req_hsh_ary << essential_req_hsh
        end

        essential_req_hsh_ary.flatten.compact.uniq
      end

      def compile_requests_analysis
        req_hsh_ary_hsh = {}
        total_essential_req_hsh_ary = []
        permission_hsh_ary = rdm_permissions
        har_path_ary = network_log_files

        har_path_ary.each do |har_path|
          puts Rainbow(har_path).green
          total_req_hsh_ary = requests(har_path)
          req_hsh_ary = json_html_requests(total_req_hsh_ary)
          essential_req_hsh_ary = extract_essential_request_data(req_hsh_ary)
          total_essential_req_hsh_ary << essential_req_hsh_ary
        end

        uniq_req_hsh_ary = total_essential_req_hsh_ary.flatten.compact.uniq

        permission_hsh_ary.each do |permission_hsh|
          permission_key = permission_hsh[:key]
          req_hsh_ary_hsh[permission_key] = uniq_req_hsh_ary
        end
        req_hsh_ary_hsh
      end

      def compile_requests_from_har_files
        req_hsh_ary_hsh = {}
        har_path_ary = network_log_files

        har_path_ary.each do |har_path|
          permission_key = File.basename(har_path, ".*")
          puts Rainbow(har_path).green
          total_req_hsh_ary = requests(har_path)
          req_hsh_ary = json_html_requests(total_req_hsh_ary)
          essential_req_hsh_ary = extract_essential_request_data(req_hsh_ary)
          req_hsh_ary_hsh[permission_key] = essential_req_hsh_ary.flatten.compact.uniq
        end
        req_hsh_ary_hsh
      end

      def save_to_json_analysis(req_hsh_ary_hsh)
        dir = [network_log_output_dir, 'analysis'].join('/')

        req_hsh_ary_hsh.each do |permission_key, req_hsh_ary|
          filename = [permission_key, '.json'].join
          json_path = [dir, filename].join('/')
          json_obj = prettify_json(req_hsh_ary)

          f = File.open(json_path, 'w')
          f.write(json_obj)
          f.close
        end
      end

      def generate_and_save_json_analysis
        req_hsh_ary_hsh = compile_requests_from_har_files
        save_to_json_analysis(req_hsh_ary_hsh)
      end

    end
  end
end
