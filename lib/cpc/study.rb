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

    def hello_class
      'Hello, this is a class method'
    end

    def hello_instance
      'Hello, this is an instance method'
    end 
  end
end
