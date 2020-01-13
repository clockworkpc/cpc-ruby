require 'spec_helper'

RSpec.describe Cpc::Util::GoogleUtil do
  include Cpc::Util::GoogleUtil

  let(:widgets_r_us_url) { 'https://docs.google.com/spreadsheets/d/13Uk4GgmAJT9hPevM6kR_THayEIpWUznpl6twqpg2U5Y/edit#gid=0' }
  let(:foo_bar_pty_ltd_url) { 'https://docs.google.com/spreadsheets/d/1_EPb9HNuf34uAFZKc1r0ieTV78JRpLd4BCk0mQXKkv8/edit?usp=drive_web&ouid=111638069551099960918' }

  context 'offline', offline: true do
    it 'should return spreadsheetId for WidgetsRUs' do
      expect(extract_spreadsheetId(widgets_r_us_url)).to eq('13Uk4GgmAJT9hPevM6kR_THayEIpWUznpl6twqpg2U5Y')
    end

    it 'should return spreadsheetId for FooBar Pty Ltd' do
      expect(extract_spreadsheetId(foo_bar_pty_ltd_url)).to eq('1_EPb9HNuf34uAFZKc1r0ieTV78JRpLd4BCk0mQXKkv8')
    end
  end



end
