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
        self.doc.xpath("//div[h1][h2][h3][div]")
      end

      def post_markdown(xml)
        h1 = xml.children.map {|c| c.text if c.name == 'h1' }.compact.first
        h2 = xml.children.map {|c| c.text if c.name == 'h2' }.compact.first
        h3 = xml.children.map {|c| c.text if c.name == 'h3' }.compact.first
        body = xml.children.map {|c| c.text if c.name == 'div' }.compact.first

        {
          h1: h1,
          h2: h2,
          h3: h3,
          body: body
        }
      end

      def save_posts
        dir = 'spec/output/blog_posts'
        posts_hsh_ary = Array.new
        post_divs.each do |xml|
          md = post_markdown(xml)
          path = [dir, md[:h1]].join('/')
          f = File.open(path, 'w')
          f.write(md[:h1])
          # Write text block and yaml front matter

        end
      end


    end
  end
end
