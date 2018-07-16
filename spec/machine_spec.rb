RSpec.describe Moory::Machine do
  let(:machine) do
    Moory::Machine.new
  end

  let(:transitions) do
    double("transition relation").tap do |dbl|
      allow(dbl).to receive(:states)
      allow(dbl).to receive(:alphabet)
    end
  end

  before do
    machine.transitions = transitions
  end

  describe '#states' do
    it 'delegates to #transitions' do
      machine.states

      expect(
        transitions
      ).to have_received(
        :states
      )
    end
  end

  describe '#alphabet' do
    it 'delegates to #transitions' do
      machine.alphabet

      expect(
        transitions
      ).to have_received(
        :alphabet
      )
    end
  end

  describe '#understand?' do
    context 'given a state-specific alphabet,' do
      before do
        machine.state = state

        allow(transitions)
          .to receive(:alphabet)
          .with(restrict: state)
          .and_return(state_alphabet)
      end

      let(:state) { '0' }
      let(:state_alphabet) { %w{ a b } }

      context 'and message therein,' do
        let(:message) { 'a' }

        it 'will return true' do
          expect(
            machine.understand?(message)
          ).to be
        end
      end

      context 'and message not therein,' do
        let(:message) { 'c' }

        it 'will return false' do
          expect(
            machine.understand?(message)
          ).not_to be
        end
      end
    end
  end
end
