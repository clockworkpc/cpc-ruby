require 'spec_helper'
require 'cpc/study/modules'

RSpec.describe Cpc::Study::Modules do
  context 'Cpc::Study::Module.new', offline: true do
    subject = Cpc::Study::Modules.new

    it 'should be able invoke an instance method in Cpc::Study' do
      expect(subject.hello_study).to eq('Hello, study!')
    end

    it 'should inherit instance methods from Cpc::StudyInstanceMethods' do
      expect(subject.hello_study_instance_methods).to eq('Hello, study instance methods!')
    end

    it 'should inherit instance methods from Cpc::StudyClassAndInstanceMethods' do
      expect(subject.hello_study_class_and_instance_methods).to eq('Hello, study class and instance methods')
    end

    it 'should not inherit Class methods from Cpc::StudyInstanceMethods' do
      expect { subject.hello_study_class_methods }.to raise_exception(NoMethodError)
    end
  end

  context 'Cpc::Study::Modules', offline: true do
    subject = Cpc::Study::Modules

    it 'should not be able invoke an instance method in Cpc::Study' do
      expect { subject.hello_study }.to raise_exception(NoMethodError)
    end

    it 'should not inherit instance methods from Cpc::StudyInstanceMethods' do
      expect { subject.hello_study_instance_methods }.to raise_exception(NoMethodError)
    end

    it 'should inherit instance methods from Cpc::StudyClassAndInstanceMethods' do
      expect(subject.hello_study_class_and_instance_methods).to eq('Hello, study class and instance methods')
    end

    it 'should inherit Class methods from Cpc::StudyInstanceMethods' do
      expect(subject.hello_study_class_methods).to eq('Hello, study class methods!')
    end
  end
end
