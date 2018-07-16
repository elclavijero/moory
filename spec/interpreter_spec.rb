RSpec.describe Moory::Interpreter do
  let(:interpreter) do
    Moory::Interpreter.new
  end

  let(:transition_relation) do
    double("transition relation").tap do |dbl|
      allow(dbl).to receive(:states)
      allow(dbl).to receive(:alphabet)
    end
  end

  before do
    interpreter.transition_relation = transition_relation
  end

  describe '#states' do
    it 'delegates to #transition_relation' do
      interpreter.states

      expect(
        transition_relation
      ).to have_received(
        :states
      )
    end
  end

  describe '#alphabet' do
    it 'delegates to #transition_relation' do
      interpreter.alphabet

      expect(
        transition_relation
      ).to have_received(
        :alphabet
      )
    end
  end

  describe '#understand?' do
    context 'given a state-specific alphabet,' do
      before do
        allow(transition_relation)
          .to receive(:alphabet)
          .with(restrict: state)
          .and_return(state_alphabet)
      end

      let(:state) { '0' }
      let(:state_alphabet) { %w{ a b } }

      context 'and message from therein,' do
        let(:message) { 'a' }

        it 'will return true'
      end
    end
  end
end
