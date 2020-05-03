# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Toolkit::LinksExtractor do
  describe 'Lesson Homepage', offline: true do
    before(:each) do
      html_path = 'spec/fixtures/debeselis/debeselis.html'
      @subject = Cpc::Toolkit::LinksExtractor.new(html_path)
    end

    it 'should extract links of other lessons' do
      links = @subject.lesson_links
      f = File.open('spec/fixtures/debeselis/links_list.txt', 'w')
      links.each { |l| f.write("#{l}\n") }
      f.close
      Clipboard.copy File.read('spec/fixtures/debeselis/links_list.txt')
    end
  end
end
