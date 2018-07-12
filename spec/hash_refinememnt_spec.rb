RSpec.describe Moory::HashRefinement do
  using Moory::HashRefinement
  
  let(:dom) do
    %w{ x y z }
  end

  let(:rng) do
    %w{ a b c }
  end

  let(:some_hash) do
    Hash[*dom.zip(rng).flatten]
  end

  describe '#then' do
    it '{} is a right-zero of #then' do
      expect(some_hash.then({})).to eq({})
    end
  end
end
