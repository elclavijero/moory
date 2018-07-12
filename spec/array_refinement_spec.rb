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
  end
end
