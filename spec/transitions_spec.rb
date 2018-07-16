RSpec.describe Moory::Transition::Storage do
  let(:transitions) do
    Moory::Transition::Storage.new
  end

  describe '#store' do
    context 'given parameters including at least origin, stimulus, and settlement' do
      context 'before anything has been stored' do
        it 'will increase #count from 0 to 1' do
          expect{
            transitions.store(origin: '0', stimulus: 'a', settlement: '1')
          }.to change{
            transitions.count
          }.from(
            0
          ).to(
            1
          )
        end
  
        it 'the stored response may then be retrieved using #the' do
          transitions.store(origin: '0', stimulus: 'a', settlement: '1')
  
          expect(
            transitions.the(origin: '0', stimulus: 'a')
          ).to eq(
            settlement: '1'
          )
        end
      end

      context 'when the origin and stimulus have already been stored' do
        before do
          transitions.store(
            origin: '0',
            stimulus: 'a',
            settlement: '1',
            output: 'x',
            effector: 'foo')
        end

        it 'will not increase #count' do
          expect{
            transitions.store(origin: '0', stimulus: 'a', settlement: '2')
          }.not_to change{ 
            transitions.count
          }
        end

        it 'will overwrite the existing settlement, output, and effector' do
          transitions.store(
            origin: '0', 
            stimulus: 'a', 
            settlement: '2',
            output: 'y',
            effector: 'bar')

          expect(
            transitions.the(origin: '0', stimulus: 'a')
          ).to eq(
            settlement: '2',
            output: 'y',
            effector: 'bar'
          )
        end
      end

      context 'when the storage is inhabited by representatives for other poise' do
        before do
          transitions.store(
            origin: '0',
            stimulus: 'a',
            settlement: '1',
            output: 'x',
            effector: 'foo')
        end

        it 'will increase #count by 1' do
          expect{
            transitions.store(origin: '1', stimulus: 'a', settlement: '1')
          }.to change{
            transitions.count
          }.by(
            1
          )
        end
      end
    end
  end

  let(:ab_star_rules) do
    [
      { origin: '0', stimulus: 'a', settlement: '1' },
      { origin: '0', stimulus: 'b', settlement: '2' },
      { origin: '1', stimulus: 'a', settlement: '2' },
      { origin: '1', stimulus: 'b', settlement: '1' },
      { origin: '2', stimulus: 'a', settlement: '2' },
      { origin: '2', stimulus: 'b', settlement: '2' },
      { origin: '2', stimulus: 'c', settlement: '2' },
    ]
  end

  describe '#alphabet' do
    before do
      ab_star_rules.each { |r| transitions.store(r) }
    end

    it 'will enumerate the alphabet applicable' do
      expect(
        transitions.alphabet
      ).to eq(
        Set['a', 'b', 'c']
      )
    end

    describe 'restricting the alphabet to a known origin' do
      it 'will enumerate the subset of the alphabet applicable to the given origin' do
        expect(
          transitions.alphabet(restrict: '0')
        ).to eq(
          Set['a', 'b']
        )
      end
    end
  end

  context 'given parameters having falsy origin, stimulus, or settlement' do
    it 'will not increase #count' do
      falsy_origin     = { origin: nil, stimulus: '',    settlement: '' }
      falsy_stimulus   = { origin: '',  stimulus: false, settlement: '' }
      falsy_settlement = { origin: '',  stimulus: '' }
      expect{ transitions.store(falsy_origin)     }.not_to change{ transitions.count }
      expect{ transitions.store(falsy_stimulus)   }.not_to change{ transitions.count }
      expect{ transitions.store(falsy_settlement) }.not_to change{ transitions.count }
    end
  end
end
