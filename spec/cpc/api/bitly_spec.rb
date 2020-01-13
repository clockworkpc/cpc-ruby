# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Api::Bitly do
  include Cpc::Util::CollectionUtil
  include Cpc::Util::StringUtil

  context 'Bitly with OAuth Token', online: true do

    it 'should shorten an HTTP link' do
      long_url = 'http://www.clockworkpc.com.au'
      res = subject.shorten(long_url)
      url_check = open(res.body['link']).base_uri.to_s
      expect(url_check).to eq(long_url + '/')
    end

    it 'should shorten an HTTPS link' do
      long_url = 'https://www.google.com'
      res = subject.shorten(long_url)
      url_check = open(res.body['link']).base_uri.to_s
      expect(url_check).to eq(long_url + '/')
    end

    it 'should expand a bitlink' do
      bitlink = 'http://bit.ly/37pDyaG'
      res = subject.expand(bitlink)
      expect(res.body['long_url']).to eq('http://www.clockworkpc.com.au/')
    end

    it 'should retrieve a bitlink' do
      bitlink = 'http://bit.ly/37pDyaG'
      res = subject.retrieve(bitlink)
      expect(res.body['long_url']).to eq('http://www.clockworkpc.com.au/')
      expect(res.body['client_id']).to eq(ENV['BITLY_CLIENT_ID'])
    end
  end

  # context 'Bitly with OAuth Token', online: true do
  #   it 'should retrieve bitly user details' do
  #     res = subject.retrieve_user('clockworkpc@gmail.com')
  #     binding.pry
  #     expect(res.body['emails'].first).to eq('clockworkpc@gmail.com')
  #     expect(res.body['login']).to eq('clockworkpc')
  #   end
  # end
end
