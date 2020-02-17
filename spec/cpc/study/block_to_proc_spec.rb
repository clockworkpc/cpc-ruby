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

  context 'Proc', offline: true do
    it 'should be invoked with #call' do
      p = Proc.new { |x| x }
      expect(p.call('hello world')).to eq('hello world')
    end

    it 'should be invoked with #yield' do
      p = Proc.new { |x| x }
      expect(p.yield('hello world')).to eq('hello world')
    end

    it 'should be invoked with a dot and parantheses' do
      p = Proc.new { |x| x }
      expect(p.('hello world')).to eq('hello world')
    end

    it 'should be invoked with square brackets' do
      p = Proc.new { |x| x }
      expect(p['hello world']).to eq('hello world')
    end

    it 'should discard extra arguments' do
      p = Proc.new { |x, y| [x, y]}
      expect(p.call('hello', 'world', 'extra')).to eq(['hello', 'world'])
    end

    it 'should replace missing arguments with nil' do
      p = Proc.new { |x, y, z| [x, y, z] }
      expect(p.call('a')).to eq(['a', nil, nil])
      expect(p.call('a', 'b')).to eq(['a', 'b', nil])
    end

    it 'should require three arguments' do
      p = Proc.new { |x, y, z| [x, y, z] }
      expect(p.arity).to eq(3)
    end

    it 'should populate mandatory arguments first' do
      p = Proc.new { |x, *y, z| {x: x, y: y, z: z } }
      expect(p.arity).to eq(-3)
      expect(p.call('x', 'z')).to eq({ x: 'x', y: [], z: 'z' })
    end

    it 'should raise a SyntaxError if more than one argument is optional' do
      # expect { p = Proc.new { |*a, *b, c, d | [a,b,c,d] } }
      #   .to raise_exception
    end

  end

  context 'Lambda', offline: true do
    it 'should behave like a Proc with a single argument' do
      lam = lambda { |x| x }
      expect(lam.call('hello world')).to eq('hello world')
      expect(lam.yield('hello world')).to eq('hello world')
      expect(lam.('hello world')).to eq('hello world')
      expect(lam['hello world']).to eq('hello world')
    end

    it 'should behave the same as a normal lambda (stabby lambda)' do
      lam = ->(x) { x }
      expect(lam.call('hello world')).to eq('hello world')
      expect(lam.yield('hello world')).to eq('hello world')
      expect(lam.('hello world')).to eq('hello world')
      expect(lam['hello world']).to eq('hello world')
    end

    it 'should raise an ArgumentError if too many arguments are provided' do
      lam = lambda { |x, y| [x, y] }
      expect { lam.call('a', 'b', 'c') }.to raise_exception(ArgumentError)
    end

    it 'should raise an ArgumentError if too fow argument are provided' do
      lam = lambda { |x, y| [x, y] }
      expect { lam.call('a') }.to raise_exception(ArgumentError)
    end

    it 'should require three arguments' do
      lam = lambda { |x, y, z| [x, y, z] }
      expect(lam.arity).to eq(3)
    end
  end

end
