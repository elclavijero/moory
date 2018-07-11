RSpec.describe Moory::Arrow do
  describe 'eql?' do
    let(:arw) do
      Moory::Arrow.new(source: '0', label: 'a', target: {})
    end

    it 'will return true if other agrees on source, label, and target' do
      other = Moory::Arrow.new(source: '0', label: 'a', target: {})

      expect(arw).to eql(other)
    end

    it 'will return false if other disagrees on source, label, or target' do
      a_different_arw = Moory::Arrow.new(source: '1', label: 'a', target: {})
      another_different_arw = Moory::Arrow.new(source: '0', label: 'b', target: {})
      yet_another_different_arw = Moory::Arrow.new(source: '0', label: 'a', target: [])

      expect(arw).not_to eql(a_different_arw)
      expect(arw).not_to eql(another_different_arw)
      expect(arw).not_to eql(yet_another_different_arw)
    end
  end

  describe '#valid?' do
    it 'will be true when source, label, and target are truthy' do
      arw = Moory::Arrow.new(source: '0', label: 'a', target: {})

      expect(arw).to be_valid
    end

    it 'will be false if source, label, or target is falsy' do
      arw_falsy_src = Moory::Arrow.new(source: nil, label: 'a', target: {})
      arw_falsy_label = Moory::Arrow.new(source: '0', label: nil, target: {})
      arw_falsy_target = Moory::Arrow.new(source: '0', label: 'a', target: nil)
      
      expect(arw_falsy_src).not_to be_valid
      expect(arw_falsy_label).not_to be_valid
      expect(arw_falsy_target).not_to be_valid
    end
  end
end
