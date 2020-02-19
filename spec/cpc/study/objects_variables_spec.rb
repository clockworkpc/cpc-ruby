RSpec.describe "Objects vs Variables" do
  context 'Objects and Variables', offline: true do
    it 'two variables can point to the same object in memory' do
      a = "abc"
      b = a
      expect(a.object_id).to eq(b.object_id)
    end

    it 'the change to an object can be seen from both pointers' do
      a = "abc"
      b = a
      a.upcase!
      expect(a).to eq("ABC")
      expect(b).to eq("ABC")
    end

    it '#clone creates a new copy of an object' do
      a = "abc"
      b = a.clone
      expect(a.object_id).not_to eq(b.object_id)
    end
  end
end
