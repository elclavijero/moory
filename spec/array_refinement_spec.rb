RSpec.describe Moory::CollectionRefinement do
  using Moory::CollectionRefinement::ArrayRefinement
  using Moory::CollectionRefinement::HashRefinement

  describe '#map_to' do
    it '[] is the left-zero of #map_to' do
      expect(
        [].map_to([])
      ).to eq(
        {}
      )

      expect(
        [].map_to([1,2,3])
      ).to eq(
        {}
      )
    end

    context 'when the array is inhabited' do
      let(:the_array) do
        %w{ x y z }
      end

      context 'and the other is an array of equal size' do
        let(:the_other) do
          %w{ a b c}
        end

        describe 'the returned hash' do
          let(:returned) do
            the_array.map_to(the_other)
          end

          it 'will be an inhabited map' do
            expect(returned).to eq({
              "x"=>"a",
              "y"=>"b",
              "z"=>"c",
            })
          end

          it 'will have a domain *equal* to {*the_array}' do
            expect(
              returned.domain
            ).to eq(
              the_array.to_set
            )
          end

          it 'will have a range *equal* to {*the_array}' do
            expect(
              returned.range
            ).to eq(
              the_other.to_set
            )
          end
        end

      end

      context 'and the other is smaller' do
        let(:the_other) do
          %w{ a b }
        end

        describe 'the returned hash' do
          let(:returned) do
            the_array.map_to(the_other)
          end

          it 'will be an inhabited map' do
            expect(returned).to eq({
              "x"=>"a",
              "y"=>"b",
            })
          end

          it 'will have a domain that is a *proper* subset of {*the_array}' do
            expect(
              returned.domain
            ).to be < the_array.to_set
          end

          it 'will have a range that is *equal* to {*the_other}' do
            expect(
              returned.range
            ).to eq(
              the_other.to_set
            )
          end
        end
      end

      context 'and the other is larger' do
        let(:the_other) do
          %w{ a b c d}
        end

        describe 'the returned hash' do
          let(:returned) do
            the_array.map_to(the_other)
          end

          it 'will be an inhabited map' do
            expect(returned).to eq({
              "x"=>"a",
              "y"=>"b",
              "z"=>"c",
            })
          end

          it 'will have a domain *equal* to {*the_array}' do
            expect(
              returned.domain
            ).to eq(
              the_array.to_set
            ) 
          end

          it 'will have a range that is a *proper* subset of {*the_other}' do
            expect(
              returned.range
            ).to be < the_other.to_set
          end
        end
      end
    end
  end

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
