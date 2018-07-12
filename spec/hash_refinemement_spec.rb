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

  describe '#then' do
    it '{} is the right-zero of #then' do
      expect(
        d_to_r.then( {} )
      ).to eq( 
        {} 
      )
    end
  end
end
