require 'spec_helper'

RSpec.describe Cpc::Study::ExecuteAround do

  context 'Basic', offline: true do
    it 'should...' do
      t = subject.with_timing {sleep 0.5}
      expect(t[:time_taken].to_f.round(1)).to eq(0.5)
    end
  end
end
