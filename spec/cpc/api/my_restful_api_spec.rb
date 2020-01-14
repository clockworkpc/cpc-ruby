require 'spec_helper'

RSpec.describe Cpc::Api::MyRestfulApi do

  context 'Node and Express on Port 4000', online: true do
    url = 'http://localhost'
    port = 4000
    subject = Cpc::Api::MyRestfulApi.new(url, port)

    it "should get root page" do
      res = subject.get_root
      expect(res.code).to eq(200)
      expect(res.body).to eq('Node and Express server running on port 4000')
      expect(res.headers["x-powered-by"]).to eq('Express')
    end

    it "should GET contact" do
      res = subject.get_contact
      expect(res.code).to eq(200)
      expect(res.body).to eq('GET request successful')
      expect(res.headers["x-powered-by"]).to eq('Express')
    end

    it "should POST contact" do
      res = subject.post_contact
      expect(res.code).to eq(200)
      expect(res.body).to eq('POST request successful')
      expect(res.headers["x-powered-by"]).to eq('Express')
    end

    it "should PUT contact" do
      res = subject.put_contact(100)
      expect(res.code).to eq(200)
      expect(res.body).to eq('PUT request successful')
      expect(res.headers["x-powered-by"]).to eq('Express')
    end

    it "should DELETE contact" do
      res = subject.delete_contact(100)
      expect(res.code).to eq(200)
      expect(res.body).to eq('DELETE request successful')
      expect(res.headers["x-powered-by"]).to eq('Express')
    end
  end
end
