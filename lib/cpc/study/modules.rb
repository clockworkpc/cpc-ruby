require 'cpc/study'

module Cpc
  module Study
    class Modules
      include Cpc::StudyInstanceMethods
      extend Cpc::StudyClassMethods
      include Cpc::StudyClassAndInstanceMethods

      def hello_study
        Study.hello_study
      end

    end
  end
end
