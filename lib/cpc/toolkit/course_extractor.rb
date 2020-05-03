# frozen_string_literal: true

module Cpc
  module Toolkit
    class CourseExtractor
      def initialize((feed_path))
        @doc = File.open(feed_path) { |f| Nokogiri::HTML(f) }
      end

      def lesson_titles
        xpath = '//*[@class="classroom-toc-item-layout__title t-14 t-white ember-view"]'
        messy_title_ary = @doc.xpath(xpath).text.strip.split("\n")
        clean_title_ary = messy_title_ary
                          .select do |t|
          t.match?(/[A-Za-z]/) unless t.match?('(Viewed)')
        end
                          .map(&:strip)

        clean_title_ary.reject { |t| t.match?('(Viewed)') || t.match?('Chapter Quiz') }
     end
    end
  end
end
