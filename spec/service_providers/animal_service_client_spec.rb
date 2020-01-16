require_relative 'pact_helper'

RSpec.describe Cpc::Pact::AnimalServiceClient, pact: true do
  before do
    Cpc::Pact::AnimalServiceClient.base_uri('localhost:1234')
  end

  subject { Cpc::Pact::AnimalServiceClient.new }

  describe "get_alligator", online: true do

    before do
      animal_service.given("an alligator exists").
        upon_receiving("a request for an alligator").
        with(method: :get, path: '/alligator', query: '').
        will_respond_with(
          status: 200,
          headers: {'Content-Type' => 'application/json'},
          body: {name: 'Betty'} )
    end

    it "returns a alligator" do
      expect(subject.get_alligator).to eq(Cpc::Pact::AnimalService::Alligator.new('Betty'))
    end
  end
end
