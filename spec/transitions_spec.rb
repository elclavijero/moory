RSpec.describe Moory::Transition::Storage do
  let(:transitions) do
    Moory::Transition::Storage.new
  end

  describe '#store' do
    context 'given parameters including at least origin, stimulus, and settlement' do
      context 'providing they have not already been stored' do
        it 'will increase #count by 1' do
          expect{
            transitions.store(origin: '0', stimulus: 'a', settlement: '1')
          }.to change{
            transitions.count
          }.by(
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

      context 'when those parameters have already been stored' do
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
    end
  end

  describe '#receptors' do
    before do
      transitions.store(origin: '0', stimulus: 'a', settlement: '1')
      transitions.store(origin: '0', stimulus: 'b', settlement: '2')
      transitions.store(origin: '1', stimulus: 'a', settlement: '2')
      transitions.store(origin: '1', stimulus: 'b', settlement: '1')
      transitions.store(origin: '2', stimulus: 'a', settlement: '2')
      transitions.store(origin: '2', stimulus: 'b', settlement: '2')
    end

    context 'given a known origin' do
      it 'will enumerate the "receptors"' do
        expect(
          transitions.receptors(origin: '0')
        ).to eq(
          [
            { 'a' => { settlement: '1' }, 'b' => { settlement: '2' } },
          ]
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
