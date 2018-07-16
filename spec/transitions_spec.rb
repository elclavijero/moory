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
          transitions.store(origin: '0', stimulus: 'a', settlement: '1')
        end

        it 'will not increase #count' do
          expect{
            transitions.store(origin: '0', stimulus: 'a', settlement: '2')
          }.not_to change{ 
            transitions.count
          }
        end
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
