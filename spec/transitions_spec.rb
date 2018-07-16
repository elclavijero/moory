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
    end
  end
end
