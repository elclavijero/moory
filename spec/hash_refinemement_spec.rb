RSpec.describe Moory::CollectionRefinement do
  using Moory::CollectionRefinement::ArrayRefinement
  using Moory::CollectionRefinement::HashRefinement
  
  let(:d) do
    %w{ x y z }
  end

  let(:r) do
    %w{ a b c }
  end

  let(:s) do
    %w{ foo bar baz }
  end

  let(:d_to_r) do
    d.map_to(r)
  end

  let(:r_to_s) do
    r.map_to(s)
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

  describe '#composable?' do
    context 'when the range is a subset of the domain of other' do
      it 'will return true' do
        expect(d_to_r.composable?(r_to_s)).to be
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

    context 'when the other is inhabited' do
      context 'when other is the identity' do
        it 'returns a copy of self' do
          expect(
            d_to_r.then( r.identity_map )
          ).to eq(
            d_to_r
          )
        end
      end

      context 'when the other differs from the identity' do
        context "the other is not composable" do
          it 'will return {}' do
            expect(
              d_to_r.then( { 'd' => '4', 'e' => '5', 'g' => '6' } )
            ).to eq(
              {}
            )
          end

          context 'the other is composable' do
            it 'will return their composition' do
              expect(
                d_to_r.then(r_to_s)
              ).to eq({
                "x"=>"foo",
                "y"=>"bar",
                "z"=>"baz"
              })
            end
          end
        end
      end
    end
  end

  describe '#project' do
    it 'will the projection of the map over the given arguments' do
      expect(
        d_to_r.project('x', 'z')
      ).to eq({
        "x"=>"a",
        "z"=>"c"
      })

      expect(
        d_to_r.project('not', 'in', 'domain')
      ).to eq(
        {}
      )
    end
  end
end
