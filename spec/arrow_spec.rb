RSpec.describe Moory::Arrow do
  describe '#valid?' do
    it 'will be true when source, label, and target are truthy' do
      arw = Moory::Arrow.new(source: '0', label: 'a', target: {})

      expect(arw).to be_valid
    end

    it 'will be false if source is falsy' do
      arw = Moory::Arrow.new(source: nil, label: 'a', target: {})

      expect(arw).not_to be_valid
    end

    it 'will be false if label is falsy' do
      arw = Moory::Arrow.new(source: '0', label: nil, target: {})

      expect(arw).not_to be_valid
    end

    it 'will be false if target is falsy' do
      arw = Moory::Arrow.new(source: '0', label: 'a', target: nil)

      expect(arw).not_to be_valid
    end
  end
end
