require_relative '../util/string_util'

module Cpc
  module Toolkit
    class BlogConverter
      include Cpc::Util::StringUtil

      attr_reader :doc

      def initialize(feed_path)
        @doc = File.open(feed_path) { |f| Nokogiri::HTML(f) }
      end

      def front_matter_template
        <<~HEREDOC
        ---
        layout: post
        title: '__TITLE__'
        date: '__DATE__'
        tags: []
        ---
        __AUTHOR__

        __BODY__
        HEREDOC
      end

      def post_divs
        self.doc.xpath("//div[h1][h2][h3][div]")
      end

      def extract_text_from_xml(xml)
        h1 = xml.children.map {|c| c.text if c.name == 'h1' }.compact.first
        h2 = xml.children.map {|c| c.text if c.name == 'h2' }.compact.first
        h3 = xml.children.map {|c| c.text if c.name == 'h3' }.compact.first
        body = xml.children.map {|c| c.text if c.name == 'div' }.compact.first

        {
          title: h1,
          author: h2,
          date: h3,
          body: body.sub(/([\:\.])/, "#{$1}\n"),
          basename: [StringUtil.convert_to_file_basename(h1), 'md'].join('.')
        }
      end

      def generate_blog_post(post_hsh)
        blog_post = front_matter_template
          .sub('__TITLE__', post_hsh[:title])
          .sub('__DATE__', post_hsh[:date])
          .sub('__AUTHOR__', post_hsh[:author])
          .sub('__BODY__', post_hsh[:body])
        blog_post.strip
      end
      
      def save_post(xml, dir)
        post_hsh = extract_text_from_xml(xml)
        blog_post = generate_blog_post(post_hsh)
        path = [dir, post_hsh[:basename]].join('/')
        f = File.open(path, 'w')
        f.write(blog_post)
        f.close
      end

      # def save_post()
      #   dir = 'spec/output/blog_posts'
      #   posts_hsh_ary = Array.new
      #   post_divs.each do |xml|
      #   end
      # end


    end
  end
end
