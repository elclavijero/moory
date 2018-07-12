RSpec.describe Moory::CollectionRefinement do
  using Moory::CollectionRefinement::ArrayRefinement
  using Moory::CollectionRefinement::HashRefinement
  
  let(:d) do
    %w{ x y z }
  end

  let(:r) do
    %w{ a b c }
  end

  let(:d_to_r) do
    d.map_to(r)
  end

  describe '#domain' do
    context 'for {}' do
      it 'will return an empty collection' do
        expect(
          {}.domain
        ).to be_empty
      end
    end

    context 'for an inhabited Hash' do
      it 'will its collection of keys' do
        expect(
          d_to_r.domain
        ).to eq(
          d.to_set
        )
      end
    end
  end

  describe '#range' do
    context 'for {}' do
      it 'will return an empty collection' do
        expect(
          {}.range
        ).to be_empty
      end
    end

    context 'for an inhabited Hash' do
      it 'will its collection of values' do
        expect(
          d_to_r.range
        ).to eq(
          r.to_set
        )
      end
    end
  end

  describe '#then' do
    context 'when other is {}' do
      it 'it returns {}' do
        expect(
          d_to_r.then( {} )
        ).to eq( 
          {} 
        )
      end
    end

    context 'when other is the identity' do
      it 'returns a copy of self' do
        pp r.identity_map
        expect(
          d_to_r.then( r.identity_map )
        ).to eq(
          d_to_r
        )
      end
    end
  end
end
