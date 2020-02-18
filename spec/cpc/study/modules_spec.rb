require 'spec_helper'
require 'cpc/study/modules'

RSpec.describe Cpc::Study::Modules do
  context 'Cpc::Study', offline: true do
    it 'should inherit method from Module' do
      expect(subject.hello_study).to eq('Hello, study!')
    end

    it 'should include an instance method from a Module' do
      expect(Cpc::Study::Modules.new.hello_study_instance_methods)
      .to eq('Hello, study instance methods!')
    end

    it 'should extend a Class method from a Module' do
      expect(Cpc::Study::Modules.hello_study_class_methods)
      .to eq('Hello, study class methods!')
    end

    it 'should both include an extend from a Module' do
      expect(Cpc::Study::Modules.new.hello_instance).to eq('Hello, this is an instance method')
      expect(Cpc::Study::Modules.new.hello_class).to eq('Hello, this is a class method')
    end

    it 'should both include an extend from a Module' do
      expect(Cpc::Study::Modules.hello_class).to eq('Hello, this is a class method')
      expect(Cpc::Study::Modules.hello_instance).to eq('Hello, this is an instance method')
    end
  end
end
