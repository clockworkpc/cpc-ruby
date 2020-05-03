# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Toolkit::WordsGenerator do
  describe 'Sample Words', offline: true do
    before(:all) do
      nouns = 'spec/fixtures/words_generator/nouns.txt'
      adjectives = 'spec/fixtures/words_generator/adjectives.txt'
      interrogative_pronouns = 'spec/fixtures/words_generator/interrogative_pronouns.txt'
      @subject = Cpc::Toolkit::WordsGenerator.new({ nouns: nouns, adjectives: adjectives, interrogative_pronouns: interrogative_pronouns })
    end

    it 'should generate a markdown table of words to decline' do
      expect(@subject.noun_adjective).to eq('hello')
    end
  end
end
