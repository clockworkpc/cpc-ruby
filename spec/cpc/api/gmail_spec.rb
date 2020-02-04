# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Api::Gmail do
  include Cpc::Util::FileParseUtil
  include Cpc::Util::GoogleUtil

  let(:user_labels_hsh_ary) { JSON.parse(File.read('spec/fixtures/gmail/labels.json')) }

  context 'cpc', online: true do
    subject = Cpc::Api::Gmail.new('cpc')

    it 'should retrieve list of folders' do
      expect(subject.all_user_labels).to eq(user_labels_hsh_ary)
    end

  end
end
