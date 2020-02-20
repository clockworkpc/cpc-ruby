require_relative '../util/file_parse_util'
require_relative '../util/collection_util'

module Cpc
  module Toolkit
    class BlogConverter
      include Cpc::Util::FileParseUtil
      include Cpc::Util::CollectionUtil

      attr_reader :doc

      def initialize(feed_path)
        @doc = File.open(feed_path) { |f| Nokogiri::HTML(f) }
      end

      def post_divs
        x = self.doc.xpath("//div")
        binding.pry
      end

      def post_headers
        self.doc.xpath("//div//h1").map {|h1| h1.text}
      end

      def post_dates
        self.doc.xpath("//div/h2").map {|h2| h2.text}
      end

      def add_post_headers_to_collection(posts_hsh)
        post_headers.each_with_index {|n,i| posts_hsh["post_#{i}"] = {h1: n} }
      end

      def add_post_dates_to_collection(posts_hsh)
        # post_dates.each_with_index do |n, i|
        #   key = "post_"
        # end
      end



      def posts
        posts_hsh = Hash.new
        add_post_headers_to_collection(posts_hsh)

        binding.pry
      end


    end
  end
end
