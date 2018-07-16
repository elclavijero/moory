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
    
      allow(dbl).to receive(:always).and_return(always_called)
    end
  end

  let(:effector_name) { 'effector' }

  let(:always_called) do
    spy("always called")
  end

  let(:sometimes_called) do
    spy("sometimes called")
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
    # NB: I think we can say: response ⇒ understand?
    # but I'll need to prove this.
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
      machine.always = always_called

      expect(
        repertoire
      ).to have_received(
        :always=
      ).with(
        always_called
      )
    end
  end

  describe '#fallback=' do
    it 'delegates to #repertoire' do
      machine.fallback = sometimes_called

      expect(
        repertoire
      ).to have_received(
        :fallback=
      ).with(
        sometimes_called
      )
    end
  end

  describe '#issue' do
    describe 'STATE TRANSITIONS' do
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
                machine.issue(understood)
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
                machine.issue(understood)
              }.not_to change {
                machine.state
              }
            end
          end
        end

        context 'the given message is NOT understood,' do
          let(:not_understood) { 'not_understood' }

          before do
            allow(transitions)
              .to receive(:response)
              .with(origin: before_state, stimulus: not_understood)
              .and_return(
                nil
              )
          end

          it 'will not change #state' do
            expect{
              machine.issue(not_understood)
            }.not_to change {
              machine.state
            }
          end
        end
      end
    end

    describe 'ALWAYS INVOCATION' do
      context 'providing #state is defined,' do
        before do
          machine.state = before_state
        end

        let(:before_state) { '0' }

        context 'and the given message is understood,' do
          let(:understood) { 'understood' }

          context 'and the response defines output' do
            before do
              allow(transitions)
                .to receive(:response)
                .with(origin: before_state, stimulus: understood)
                .and_return(
                  settlement: before_state,
                  output: some_output
              )
            end

            let(:some_output) { 'some output' }

            it 'will invoke #always from the repertoire with arguments' do
              machine.issue(understood)
  
              expect(
                always_called
              ).to have_received(
                :call
              ).with(
                some_output
              )
            end
          end

          context 'but the response does not define output' do  
            before do
              allow(transitions)
                .to receive(:response)
                .with(origin: before_state, stimulus: understood)
                .and_return(
                  settlement: before_state,
              )
            end
  
            it 'will invoke #always from the repertoire without arguments' do
              machine.issue(understood)
  
              expect(
                always_called
              ).to have_received(
                :call
              ).with(
                no_args
              )
            end
          end
        end
      end
    end

    describe 'RECOLLECTION INVOCATION' do
      context 'providing #state is defined,' do
        before do
          machine.state = before_state
        end

        let(:before_state) { '0' }

        context 'the given message is understood,' do
          let(:understood) { 'understood' }

          context 'the response defines an effector, and output' do
            before do
              allow(transitions)
                .to receive(:response)
                .with(origin: before_state, stimulus: understood)
                .and_return(
                  settlement: before_state,
                  output: some_output,
                  effector: effector_name
              )

              allow(repertoire)
                .to receive(:recall)
                .and_return(sometimes_called)
            end

            let(:some_output)   { 'some output' }

            it 'will recall the effector from the repetoire' do
              machine.issue(understood)

              expect(
                repertoire
              ).to have_received(
                :recall
              ).with(
                effector_name
              )
            end

            # it 'will call the recollection' do
            #   machine.issue(understood)

            #   expect(
            #     sometimes_called
            #   ).to have_received(
            #     :call
            #   ).with(
            #     some_output
            #   )
            # end
          end
        end
      end
    end
  end
end
