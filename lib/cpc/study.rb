module Cpc
  module Study
    def self.hello_study
      'Hello, study!'
    end

  end

  module StudyInstanceMethods
    def hello_study_instance_methods
      'Hello, study instance methods!'
    end
  end

  module StudyClassMethods
    def hello_study_class_methods
      'Hello, study class methods!'
    end
  end

  module StudyClassAndInstanceMethods
    def self.included(base)
      base.extend(StudyClassAndInstanceMethods)
    end

    def hello_study_class_and_instance_methods
      'Hello, study class and instance methods'
    end
  end
end
