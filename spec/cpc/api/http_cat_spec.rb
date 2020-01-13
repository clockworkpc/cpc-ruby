# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cpc::Api::HttpCat do
  include Cpc::Util::CollectionUtil
  include Cpc::Util::StringUtil

  # TODO: Remove before block
  # TODO: Add stubs

  # before(:all) do
  #   @port = 3000
  #
  #   case
  #   when process_running_on_port?(@port)
  #     puts Rainbow("http.cat running on port #{@port}").green
  #     url = "http://localhost:#{@port}"
  #   when npm_package_installed?('http.cat')
  #     db_dir = [Dir.home, 'Development', 'study', 'http.cat'].join('/')
  #     puts Rainbow("http.cat not running on port #{@port}").yellow
  #     puts Rainbow("Will start the server").yellow
  #     url = "http://localhost:#{@port}"
  #     system("cd #{db_dir} && yarn start </dev/null &>/dev/null &")
  #   else
  #     puts Rainbow("http.cat not installed, will send API calls to public URI").red
  #     url = 'https://http.cat'
  #   end
  #
  #   @subject = Cpc::Api::HttpCat.new(url)
  #
  #   running = true
  #   while running
  #     counter = 0.0
  #     break if process_running_on_port?(@port)
  #     counter += 0.5
  #     puts "Waited for #{counter} seconds"
  #     sleep 0.5
  #   end
  # end

  # context 'status codes', online: false do
  #
  # it 'should get image for status 100' do
  #   expect(File.read(@subject.get_status_code_100)).to eq(File.read('spec/fixtures/http_cats/100.jpg'))
  # end
  #
  # it 'should get image for status 101' do
  #   expect(File.read(@subject.get_status_code_101)).to eq(File.read('spec/fixtures/http_cats/101.jpg'))
  # end
  #
  #   it 'should get image for status 200' do
  #     expect(File.read(@subject.get_status_code_200)).to eq(File.read('spec/fixtures/http_cats/200.jpg'))
  #   end
  #
  #   it 'should get image for status 201' do
  #     expect(File.read(@subject.get_status_code_201)).to eq(File.read('spec/fixtures/http_cats/201.jpg'))
  #   end
  #
  #   it 'should get image for status 202' do
  #     expect(File.read(@subject.get_status_code_202)).to eq(File.read('spec/fixtures/http_cats/202.jpg'))
  #   end
  #
  #   it 'should get image for status 204' do
  #     expect(File.read(@subject.get_status_code_204)).to eq(File.read('spec/fixtures/http_cats/204.jpg'))
  #   end
  #
  #   it 'should get image for status 206' do
  #     expect(File.read(@subject.get_status_code_206)).to eq(File.read('spec/fixtures/http_cats/206.jpg'))
  #   end
  #
  #   it 'should get image for status 207' do
  #     expect(File.read(@subject.get_status_code_207)).to eq(File.read('spec/fixtures/http_cats/207.jpg'))
  #   end
  #
  #   it 'should get image for status 300' do
  #     expect(File.read(@subject.get_status_code_300)).to eq(File.read('spec/fixtures/http_cats/300.jpg'))
  #   end
  #
  #   it 'should get image for status 301' do
  #     expect(File.read(@subject.get_status_code_301)).to eq(File.read('spec/fixtures/http_cats/301.jpg'))
  #   end
  #
  #   it 'should get image for status 302' do
  #     expect(File.read(@subject.get_status_code_302)).to eq(File.read('spec/fixtures/http_cats/302.jpg'))
  #   end
  #
  #   it 'should get image for status 303' do
  #     expect(File.read(@subject.get_status_code_303)).to eq(File.read('spec/fixtures/http_cats/303.jpg'))
  #   end
  #
  #   it 'should get image for status 304' do
  #     expect(File.read(@subject.get_status_code_304)).to eq(File.read('spec/fixtures/http_cats/304.jpg'))
  #   end
  #
  #   it 'should get image for status 305' do
  #     expect(File.read(@subject.get_status_code_305)).to eq(File.read('spec/fixtures/http_cats/305.jpg'))
  #   end
  #
  #   it 'should get image for status 307' do
  #     expect(File.read(@subject.get_status_code_307)).to eq(File.read('spec/fixtures/http_cats/307.jpg'))
  #   end
  #
  #   it 'should get image for status 400' do
  #     expect(File.read(@subject.get_status_code_400)).to eq(File.read('spec/fixtures/http_cats/400.jpg'))
  #   end
  #
  #   it 'should get image for status 401' do
  #     expect(File.read(@subject.get_status_code_401)).to eq(File.read('spec/fixtures/http_cats/401.jpg'))
  #   end
  #
  #   it 'should get image for status 402' do
  #     expect(File.read(@subject.get_status_code_402)).to eq(File.read('spec/fixtures/http_cats/402.jpg'))
  #   end
  #
  #   it 'should get image for status 403' do
  #     expect(File.read(@subject.get_status_code_403)).to eq(File.read('spec/fixtures/http_cats/403.jpg'))
  #   end
  #
  #   it 'should get image for status 404' do
  #     expect(File.read(@subject.get_status_code_404)).to eq(File.read('spec/fixtures/http_cats/404.jpg'))
  #   end
  #
  #   it 'should get image for status 405' do
  #     expect(File.read(@subject.get_status_code_405)).to eq(File.read('spec/fixtures/http_cats/405.jpg'))
  #   end
  #
  #   it 'should get image for status 406' do
  #     expect(File.read(@subject.get_status_code_406)).to eq(File.read('spec/fixtures/http_cats/406.jpg'))
  #   end
  #
  #   it 'should get image for status 408' do
  #     expect(File.read(@subject.get_status_code_408)).to eq(File.read('spec/fixtures/http_cats/408.jpg'))
  #   end
  #
  #   it 'should get image for status 409' do
  #     expect(File.read(@subject.get_status_code_409)).to eq(File.read('spec/fixtures/http_cats/409.jpg'))
  #   end
  #
  #   it 'should get image for status 410' do
  #     expect(File.read(@subject.get_status_code_410)).to eq(File.read('spec/fixtures/http_cats/410.jpg'))
  #   end
  #
  #   it 'should get image for status 411' do
  #     expect(File.read(@subject.get_status_code_411)).to eq(File.read('spec/fixtures/http_cats/411.jpg'))
  #   end
  #
  #   it 'should get image for status 412' do
  #     expect(File.read(@subject.get_status_code_412)).to eq(File.read('spec/fixtures/http_cats/412.jpg'))
  #   end
  #
  #   it 'should get image for status 413' do
  #     expect(File.read(@subject.get_status_code_413)).to eq(File.read('spec/fixtures/http_cats/413.jpg'))
  #   end
  #
  #   it 'should get image for status 414' do
  #     expect(File.read(@subject.get_status_code_414)).to eq(File.read('spec/fixtures/http_cats/414.jpg'))
  #   end
  #
  #   it 'should get image for status 415' do
  #     expect(File.read(@subject.get_status_code_415)).to eq(File.read('spec/fixtures/http_cats/415.jpg'))
  #   end
  #
  #   it 'should get image for status 416' do
  #     expect(File.read(@subject.get_status_code_416)).to eq(File.read('spec/fixtures/http_cats/416.jpg'))
  #   end
  #
  #   it 'should get image for status 417' do
  #     expect(File.read(@subject.get_status_code_417)).to eq(File.read('spec/fixtures/http_cats/417.jpg'))
  #   end
  #
  #   it 'should get image for status 418' do
  #     expect(File.read(@subject.get_status_code_418)).to eq(File.read('spec/fixtures/http_cats/418.jpg'))
  #   end
  #
  #   it 'should get image for status 420' do
  #     expect(File.read(@subject.get_status_code_420)).to eq(File.read('spec/fixtures/http_cats/420.jpg'))
  #   end
  #
  #   it 'should get image for status 421' do
  #     expect(File.read(@subject.get_status_code_421)).to eq(File.read('spec/fixtures/http_cats/421.jpg'))
  #   end
  #
  #   it 'should get image for status 422' do
  #     expect(File.read(@subject.get_status_code_422)).to eq(File.read('spec/fixtures/http_cats/422.jpg'))
  #   end
  #
  #   it 'should get image for status 423' do
  #     expect(File.read(@subject.get_status_code_423)).to eq(File.read('spec/fixtures/http_cats/423.jpg'))
  #   end
  #
  #   it 'should get image for status 424' do
  #     expect(File.read(@subject.get_status_code_424)).to eq(File.read('spec/fixtures/http_cats/424.jpg'))
  #   end
  #
  #   it 'should get image for status 425' do
  #     expect(File.read(@subject.get_status_code_425)).to eq(File.read('spec/fixtures/http_cats/425.jpg'))
  #   end
  #
  #   it 'should get image for status 426' do
  #     expect(File.read(@subject.get_status_code_426)).to eq(File.read('spec/fixtures/http_cats/426.jpg'))
  #   end
  #
  #   it 'should get image for status 429' do
  #     expect(File.read(@subject.get_status_code_429)).to eq(File.read('spec/fixtures/http_cats/429.jpg'))
  #   end
  #
  #   it 'should get image for status 431' do
  #     expect(File.read(@subject.get_status_code_431)).to eq(File.read('spec/fixtures/http_cats/431.jpg'))
  #   end
  #
  #   it 'should get image for status 444' do
  #     expect(File.read(@subject.get_status_code_444)).to eq(File.read('spec/fixtures/http_cats/444.jpg'))
  #   end
  #
  #   it 'should get image for status 450' do
  #     expect(File.read(@subject.get_status_code_450)).to eq(File.read('spec/fixtures/http_cats/450.jpg'))
  #   end
  #
  #   it 'should get image for status 451' do
  #     expect(File.read(@subject.get_status_code_451)).to eq(File.read('spec/fixtures/http_cats/451.jpg'))
  #   end
  #
  #   it 'should get image for status 499' do
  #     expect(File.read(@subject.get_status_code_499)).to eq(File.read('spec/fixtures/http_cats/499.jpg'))
  #   end
  #
  #   it 'should get image for status 500' do
  #     expect(File.read(@subject.get_status_code_500)).to eq(File.read('spec/fixtures/http_cats/500.jpg'))
  #   end
  #
  #   it 'should get image for status 501' do
  #     expect(File.read(@subject.get_status_code_501)).to eq(File.read('spec/fixtures/http_cats/501.jpg'))
  #   end
  #
  #   it 'should get image for status 502' do
  #     expect(File.read(@subject.get_status_code_502)).to eq(File.read('spec/fixtures/http_cats/502.jpg'))
  #   end
  #
  #   it 'should get image for status 503' do
  #     expect(File.read(@subject.get_status_code_503)).to eq(File.read('spec/fixtures/http_cats/503.jpg'))
  #   end
  #
  #   it 'should get image for status 504' do
  #     expect(File.read(@subject.get_status_code_504)).to eq(File.read('spec/fixtures/http_cats/504.jpg'))
  #   end
  #
  #   it 'should get image for status 506' do
  #     expect(File.read(@subject.get_status_code_506)).to eq(File.read('spec/fixtures/http_cats/506.jpg'))
  #   end
  #
  #   it 'should get image for status 507' do
  #     expect(File.read(@subject.get_status_code_507)).to eq(File.read('spec/fixtures/http_cats/507.jpg'))
  #   end
  #
  #   it 'should get image for status 508' do
  #     expect(File.read(@subject.get_status_code_508)).to eq(File.read('spec/fixtures/http_cats/508.jpg'))
  #   end
  #
  #   it 'should get image for status 509' do
  #     expect(File.read(@subject.get_status_code_509)).to eq(File.read('spec/fixtures/http_cats/509.jpg'))
  #   end
  #
  #   it 'should get image for status 510' do
  #     expect(File.read(@subject.get_status_code_510)).to eq(File.read('spec/fixtures/http_cats/510.jpg'))
  #   end
  #
  #   it 'should get image for status 511' do
  #     expect(File.read(@subject.get_status_code_511)).to eq(File.read('spec/fixtures/http_cats/511.jpg'))
  #   end
  #
  #   it 'should get image for status 599' do
  #     expect(File.read(@subject.get_status_code_599)).to eq(File.read('spec/fixtures/http_cats/599.jpg'))
  #   end
  #
  # end
end
