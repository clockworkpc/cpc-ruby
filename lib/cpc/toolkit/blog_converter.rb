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
        title: "__TITLE__"
        date: "__DATE__"
        author: "__AUTHOR__"
        tags: []
        ---

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
        basename = [h3, "#{StringUtil.convert_to_file_basename(h1)}.md"].join('-')
        
        # body.gsub!(/\.\s*/, ".")
        # body.gsub!(/(?<foo>[A-Za-z])\./, '\k<foo>'.to_s + ".\n")
        # body.gsub!(/(?<foo>[A-Za-z])\:/, '\k<foo>'.to_s + ": ")
        # body.gsub!(/^\W(?<foo>[A-Za-z])/, "" + '\k<foo>'.to_s)



        {
          title: h1,
          author: h2,
          date: h3,
          body: body,
          basename: basename
        }

#         ryan_string = "RyanOnRails: This is a test"
# /^(?<webframework>.*)(?<colon>:)(?<rest>)/ =~ ryan_string
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
        puts blog_post
      end
      
      def save_posts(xml_ary, dir)
        xml_ary.each do |xml|
          save_post(xml, dir)
        end
      end

    end
  end
end
