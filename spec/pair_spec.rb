RSpec.describe Moory::Pair do
  describe '#eql?' do
    let(:pair) do
      Moory::Pair.new(left: '0', right: 'a')
    end

    it 'will return true if other agrees on left, right' do
      other = Moory::Pair.new(left: '0', right: 'a')

      expect(pair).to eql(other)
    end

    it 'will return false if other disagrees on left, right, or ' do
      a_different_pair = Moory::Pair.new(left: '1', right: 'a')
      another_different_pair = Moory::Pair.new(left: '0', right: 'b')

      expect(pair).not_to eql(a_different_pair)
      expect(pair).not_to eql(another_different_pair)
    end
  end

  describe '#valid?' do
    it 'will be true when left, right, and  are truthy' do
      pair = Moory::Pair.new(left: '', right: '')

      expect(pair).to be_valid
    end

    it 'will be false if left, right, or  is falsy' do
      pair_falsy_left  = Moory::Pair.new(left: nil, right: 'a')
      pair_falsy_right = Moory::Pair.new(left: '0', right: nil)
      
      expect(pair_falsy_left).not_to be_valid
      expect(pair_falsy_right).not_to be_valid
    end
  end

  describe '#shunt' do
    context 'for the pair (left: "x", right: "y")' do
      let(:pair) do
        Moory::Pair.new(left: 'x', right: 'y')
      end

      let(:a_value) do
        spy("a_value")
      end

      context 'when given a_value' do
        it 'will return { "x" => { "y" => a_value } }' do
          expect(
            pair.shunt(a_value)
          ).to eq(
            { "x" => { "y" => a_value } }
          )
        end
      end
    end
  end
end
