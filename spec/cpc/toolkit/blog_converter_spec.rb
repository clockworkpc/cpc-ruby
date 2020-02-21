require 'spec_helper'
require 'cpc/toolkit/blog_converter'

RSpec.describe Cpc::Toolkit::BlogConverter do

  let(:post_body_text) do
    <<~HEREDOC
    When I first learned Python I spent a lot of time in interactive mode:And when I finally started using Gedit, the syntax highlighting and bracket completion felt luxurious.But the time has come for a proper IDE.  I can't justify shelling out $200 for RubyMine just yet, but Atom 1.11.2 looks very promising.Of course, I could learn to use Emacs or Vim, but that's probably a bit too far for me at this stage.  I'd like to get there one day though.
    HEREDOC
  end

  context 'Large feed.html', offline: true do
    feed_path = '/home/alexandergarber/Development/publish/clockworkpc.github.io/_archive/feed.html'
    subject = Cpc::Toolkit::BlogConverter.new(feed_path)

    it 'should open feed.html with Nokogiri' do
      expect(subject.doc).to be_a(Nokogiri::HTML::Document)
    end

    it 'should return all the divs that contain posts' do
      expect(subject.post_divs.count).to eq(176)
    end

    it 'should extract the h1, h2, h3, and body div' do
      xml = subject.post_divs[6]
      post = subject.post_markdown(xml)
      expect(post[:h1]).to eq('Atom Text Editor: My New IDE?')
      expect(post[:h2]).to eq('Alexander Garber')
      expect(post[:h3]).to eq('2016-10-27')
      expect(post[:body]).to eq(post_body_text.strip)
    end

    it 'should generate ' do

    end

  end

end
