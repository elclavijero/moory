RSpec.describe Moory::Transducer do
  let(:machine) do
    Moory::Transducer.new
  end

  let(:transitions) do
    double("transition relation").tap do |dbl|
      allow(dbl).to receive(:states)
      allow(dbl).to receive(:alphabet)
      allow(dbl).to receive(:egresses)
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

  describe '#awaits' do
    it 'delegates to #transitions' do
      machine.state = '0'

      machine.awaits

      expect(
        transitions
      ).to have_received(
        :egresses
      ).with(
        state: '0'
      )
    end
  end

  describe '#understand?' do
    context 'providing the machine has been assigned a state,' do
      before do
        machine.state = state_with_egresses
      end

      let(:state_with_egresses) { '0' }

      context 'and that state has egresses,' do
        before do
          allow(transitions)
            .to receive(:egresses)
            .with(state: '0')
            .and_return(egresses)
        end

        let(:egresses) { %w{ a b c }.to_set }
  
        context 'given a stimulus belonging to egresses' do
          let(:belongs) { 'a' }
          
          it 'will return true' do
            expect(
              machine.understand?(belongs)
            ).to be
          end
        end
  
        context 'given a stimulus NOT belonging to egresses' do
          let(:does_not_belong) { 'd' }
          
          it 'will return false' do
            expect(
              machine.understand?(does_not_belong)
            ).not_to be
          end
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
          end

          context 'the response defines an effector, but lacks output' do
            before do
              allow(transitions)
                .to receive(:response)
                .with(origin: before_state, stimulus: understood)
                .and_return(
                  settlement: before_state,
                  effector: effector_name
              )

              allow(repertoire)
                .to receive(:recall)
                .and_return(sometimes_called)
            end

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

            it 'will call the recollection with no arguments' do
              machine.issue(understood)

              expect(
                sometimes_called
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
  end
end
