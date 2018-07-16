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

  let(:repertoire) do
    double("repertoire").tap do |dbl|
      allow(dbl).to receive(:always=)
      allow(dbl).to receive(:fallback=)
    end
  end

  let(:a_callable_object) do
    spy("a callable object")
  end

  before do
    machine.transitions = transitions
    machine.repertoire  = repertoire
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

  describe '#always=' do
    it 'delegates to #repertoire' do
      machine.always = a_callable_object

      expect(
        repertoire
      ).to have_received(
        :always=
      )
    end
  end

  describe '#fallback=' do
    it 'delegates to #repertoire' do
      machine.fallback = a_callable_object

      expect(
        repertoire
      ).to have_received(
        :fallback=
      )
    end
  end

  describe '#putm' do
    describe 'state transition' do
      context 'providing #state is defined,' do
        before do
          machine.state = before_state
        end

        let(:before_state) { '0' }

        context 'the given message is understood,' do
          let(:understood) { 'understood' }

          context 'and the response settlement differs from #state,' do
            before do
              allow(transitions)
                .to receive(:response)
                .with(origin: before_state, stimulus: understood)
                .and_return(
                  settlement: after_state
                )
            end
  
            let(:after_state) { '1' }
  
            it 'will change #state to that named by the response settlement' do
              expect{
                machine.putm(understood)
              }.to change {
                machine.state
              }.from(
                before_state
              ).to(
                after_state
              )
            end
          end

          context 'but the response settlement equals #state,' do
            before do
              allow(transitions)
                .to receive(:response)
                .with(origin: before_state, stimulus: understood)
                .and_return(
                  settlement: before_state
                )
            end

            it 'will not change #state' do
              expect{
                machine.putm(understood)
              }.not_to change {
                machine.state
              }
            end
          end
        end
      end
    end
  end
end
