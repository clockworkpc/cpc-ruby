# frozen_string_literal: true

module Cpc
  module Toolkit
    class LinksExtractor
      def initialize(html_path)
        @doc = File.open(html_path) { |f| Nokogiri::HTML(f) }
      end

      def lesson_links
        @doc.xpath('//a').map do |a|
          link = a.attributes['href'].value
          link if link.match?('/lesson/temp')
        end.compact.uniq
      end
    end
  end
end
