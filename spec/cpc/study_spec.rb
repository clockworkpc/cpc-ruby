require 'spec_helper'
require 'cpc/study'

RSpec.describe Cpc::Study do
  context 'Module method', offline: true do
    it 'should execute a Module method' do
      expect(Cpc::Study.hello_study).to eq('Hello, study!')
    end
  end
end
