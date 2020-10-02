# frozen_string_literal: true

module Cpc
  module Toolkit
    class VideoUrlExtractor
      def initialize((html_path))
        @doc = File.open(html_path) { |f| Nokogiri::HTML(f) }
      end

      def video_urls
        # xpath = '//*[@class="classroom-toc-item-layout__title t-14 t-white ember-view"]'
        # messy_title_ary = @doc.xpath(xpath).text.strip.split("\n")
        # clean_title_ary = messy_title_ary
        #                   .select do |t|
        #   t.match?(/[A-Za-z]/) unless t.match?('(Viewed)')
        # end
        #                   .map(&:strip)

        # clean_title_ary.reject { |t| t.match?('(Viewed)') || t.match?('Chapter Quiz') }
        xpath = '//a[@id="video-title"]'
        urls = @doc.xpath(xpath).map do |x|
          base = 'https://www.youtube.com'
          watch = x.attributes['href'].value
          full_url = [base, watch].join
          ['youtube-dl', "\"#{full_url}\""].join(' ')
        end
     end
    end
  end
end
