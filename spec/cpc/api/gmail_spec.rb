# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Api::Gmail do
  include Cpc::Util::FileParseUtil
  include Cpc::Util::GoogleUtil

  let(:user_labels_hsh_ary) { JSON.parse(File.read('spec/fixtures/gmail/labels.json'), symbolize_names: true) }

  context 'cpc', online: true do
    subject = Cpc::Api::Gmail.new('cpc')

    it 'should retrieve list of folders', online: false do
      expect(subject.all_user_labels).to eq(user_labels_hsh_ary)
    end

    it 'should retrieve all emails in the inbox' do
      expect(subject.all_emails_inbox).to eq("hello world")
    end

  end
end
