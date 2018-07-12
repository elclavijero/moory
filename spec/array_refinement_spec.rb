RSpec.describe Moory::CollectionRefinement do
  using Moory::CollectionRefinement::ArrayRefinement

  describe '#lift' do
    context 'for an empty array' do
      it 'will return {}' do
        expect(
          [].lift
        ).to eq(
          {}
        )
      end
    end

    context 'for an inhabited array' do
      it 'will return the identity map over that array' do
        expect(
          %w{ x y z }.lift
        ).to eq(
          {
            'x' => 'x',
            'y' => 'y',
            'z' => 'z'
          }
        )
      end
    end
  end
end
