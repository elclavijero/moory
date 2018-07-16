RSpec.describe Moory::Transition::Storage do
  let(:transitions) do
    Moory::Transition::Storage.new
  end

  describe '#store' do
    context 'given parameters including at least origin, stimulus, and settlement' do
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
  end
end
