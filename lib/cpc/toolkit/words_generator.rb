# frozen_string_literal: true

require 'markdown-tables'

module Cpc
  module Toolkit
    class WordsGenerator
      def initialize(**kwargs)
        @interrogative_pronouns = File.readlines(kwargs[:interrogative_pronouns])
        @nouns = File.readlines(kwargs[:nouns])
        @adjectives = File.readlines(kwargs[:adjectives])
      end

      def noun_adjective_line
        [
          @interrogative_pronouns.sample.strip,
          @nouns.sample.strip,
          @adjectives.sample.strip
        ]
      end

      def noun_adjective
        labels = %w[Klausimas Daiktavardis Būdvardis]
        interrogative_pronouns = []
        nouns = []
        adjectives = []

        10.times { interrogative_pronouns << @interrogative_pronouns.sample.strip }
        10.times { nouns << @nouns.sample.strip }
        10.times { adjectives << @adjectives.sample.strip }

        table = MarkdownTables.make_table(labels, [interrogative_pronouns, nouns, adjectives])
        MarkdownTables.plain_text(table)
      end
    end
  end
end
