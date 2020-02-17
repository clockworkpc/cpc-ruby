require 'spec_helper'

RSpec.describe Cpc::Study::BlockToProc do
  context 'Blocks', offline: true do
    it "should pass empty block" do
      p = Proc.new {|bla| "I'm a Proc that says #{bla}"}
      empty_block = subject.debug_only(p)
      expect(empty_block[:param_class]).to eq(Proc)
      expect(empty_block[:block_class]).to eq(nil)
    end

    it "should pass block with proc" do
      p = Proc.new {|bla| "I'm a Proc that says #{bla}"}
      block_with_proc = subject.debug_only(&p)
      expect(block_with_proc[:param_class]).to eq(NilClass)
      expect(block_with_proc[:block_class]).to eq(Proc)
    end
  end
end
