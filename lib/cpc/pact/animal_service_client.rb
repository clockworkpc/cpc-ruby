require 'httparty'
require_relative 'animal_service/alligator'
module Cpc
  module Pact
    class AnimalServiceClient
      include HTTParty
      base_uri('http://animal-service.com')

      def get_alligator
        name = JSON.parse(self.class.get("/alligator").body)['name']
        Cpc::Pact::AnimalService::Alligator.new(name)
      end
    end
  end
end
