# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Toolkit::VideoUrlExtractor do
  let(:html_path) { 'spec/fixtures/youtube_parser/melb_trad_page.html' }
  let(:video_url_ary) { nil }
  let(:output_path) { 'spec/output/video_urls.sh' }

  context 'html_path' do
    it 'should extract video urls', offline: true do
      subject = Cpc::Toolkit::VideoUrlExtractor.new(html_path)
      video_urls = subject.video_urls
      f = File.open(output_path, 'w')
      f.write("#!/bin/bash\n")
      video_urls.each { |v| f.write("#{v}\n") }
      f.close
      expect(subject.video_urls).to eq(video_url_ary)
    end
  end
end
