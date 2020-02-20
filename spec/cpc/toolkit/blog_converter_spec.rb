require 'spec_helper'
require 'cpc/toolkit/blog_converter'

RSpec.describe Cpc::Toolkit::BlogConverter do

  context 'Large feed.html', offline: true do
    feed_path = '/home/alexandergarber/Development/publish/clockworkpc.github.io/_archive/feed.html'
    subject = Cpc::Toolkit::BlogConverter.new(feed_path)

    it 'should open feed.html with Nokogiri' do
      expect(subject.doc).to be_a(Nokogiri::HTML::Document)
    end

    it 'should return all the divs that contain posts' do
      expect(subject.post_divs.count).to eq(183)
    end

    it 'should return all the post headers in an array of Strings' do
      expect(subject.post_headers.count).to eq(183)
    end

    it 'should return all the post dates in an array of Strings' do
      expect(subject.post_dates.count).to eq(183)
    end

    it 'should return a Hash of all the posts with h1, h2, h3' do
      expect(subject.posts).to eq('hello')
    end
  end

end
