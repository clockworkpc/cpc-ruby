module Cpc
  module Pact
    module AnimalService
      class Alligator
        attr_reader :name

        def initialize(name_str)
          @name = name_str
        end

        def == other
          other.is_a?(Alligator) && other.name == name
        end
      end
    end
  end
end
