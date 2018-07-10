RSpec.describe Moory::Interpreter do
  let(:the_interpreter) do
    Moory::Interpreter.new
  end

  describe '#states' do
    before do
      the_interpreter.graph = {
        '0' => {}, '1' => {}, '2' => {}
      }
    end

    it 'will return <Set: {"0", "1", "2"}>' do  
      expect(the_interpreter.states).to eq(%w{ 0 1 2 }.to_set)
    end
  end

  describe '#alphabet' do
    before do
      the_interpreter.graph = {
        '0' => { 'a' => {} },
        '1' => { 'b' => {} }, 
        '2' => { 'b' => {} },
      }
    end

    it 'will return <Set: {"a", "b"}>' do
      expect(the_interpreter.alphabet).to eq(%w{ a b }.to_set)
    end
  end

  describe '#receptors' do
    before(:each) do
      the_interpreter.graph = {
        '0' => { 'a' => {} },
        '1' => { 'b' => {} }, 
        '2' => { 'b' => {} },
      }
    end

    it 'will return a subset of the alphabet, depending on its state' do
      the_interpreter.state = '0'
      expect(the_interpreter.receptors).to eq(%w{ a }.to_set)

      the_interpreter.state = '1'
      expect(the_interpreter.receptors).to eq(%w{ b }.to_set)
    end
  end

  describe '#understand?' do
    context 'providing the interpreter has been assigned a state' do
      before(:each) do
        the_interpreter.graph = {
          '0' => { 'a' => {} },
          '1' => { 'b' => {} }, 
          '2' => { 'b' => {} },
        }
        the_interpreter.state = '0'
      end

      it 'will return true if given any of the receptors' do
        expect(
          the_interpreter.receptors.all? { |r| the_interpreter.understand?(r) }
        ).to be
      end
    end
  end

  describe '#putm' do
    context 'if the interpeter state is undefined' do
      before do
        the_interpreter.state = nil
      end

      it 'will write a warning to stderr' do
        expect{
          the_interpreter.putm('a_message')
        }.to output(
          /received a_message before being assigned a state/
        ).to_stderr
      end
    end
    
    describe 'transitions between states' do
      before(:each) do
        the_interpreter.graph = {
          'origin' => { 'known message' => { state: 'settlement' } }
        }
        the_interpreter.state = 'origin'
      end

      context 'when given a message that the interpreter understands' do
        it 'will settle the machine into the corresponding state' do
          expect(the_interpreter.understand?('known message')).to be

          the_interpreter.putm('known message')

          expect(the_interpreter.state).to eq('settlement')
        end
      end

      context 'when given a messsage that the interpreter does not understand' do
        context 'and the default proc is WARN' do
          before do
            the_interpreter.default_proc = Moory::Interpreter::WARN
          end

          it 'will write a message to stderr' do
            expect(the_interpreter.understand?('unknown message')).not_to be
            
            expect{
              the_interpreter.putm('unknown message')
            }.to output(
              /Did not understand: unknown message/
            ).to_stderr
          end
        end

        context 'and the default proc is SKIP' do
          before do
            the_interpreter.default_proc = Moory::Interpreter::SKIP
          end

          it 'will not write a message to stderr' do
            expect(the_interpreter.understand?('unknown message')).not_to be
            
            expect{
              the_interpreter.putm('unknown message')
            }.not_to output.to_stderr
          end
        end
      end
    end

    describe 'effector invocation' do
      let(:an_effector) do
        spy("an effector")
        # NOTE: Spies are variadic (they have arity -1)
      end

      let(:the_fallback_effector) do
        spy("the fallback effector")
      end

      let(:full_graph) do
        {
          'origin' => { 'stimulus' => 
            { 
              state:    'settlement', 
              output:   'hello',
              effector: an_effector
            } 
          }
        }
      end

      let(:graph_lacks_effector) do
        {
          'origin' => { 'stimulus' => 
            { 
              state:    'settlement', 
              output:   'hello',
            } 
          }
        }
      end

      let(:graph_lacks_output) do
        {
          'origin' => { 'stimulus' => 
            { 
              state:    'settlement', 
              effector: an_effector
            } 
          }
        }
      end

      let(:graph_lacks_both_output_and_effector) do
        {
          'origin' => { 'stimulus' => 
            { 
              state:    'settlement',
            } 
          }
        }
      end

      before(:each) do
        the_interpreter.state = 'origin'
      end

      context 'when the transition has associated output' do
        context 'and the transition is associated with an effector' do
          before do
            the_interpreter.graph = full_graph
          end

          it 'will call that effector, supplying the output as its argument' do
            the_interpreter.putm('stimulus')

            expect(an_effector).to have_received(:call).with('hello')
          end
        end

        context 'but the transition is not associated with an effector' do
          before do
            the_interpreter.graph = graph_lacks_effector
          end

          context 'and the fallback effector has been defined' do
            before do
              the_interpreter.fallback_effector = the_fallback_effector
            end
            it 'will call the fallback effector, supplying the output as its argument' do
              the_interpreter.putm('stimulus')

              expect(the_fallback_effector).to have_received(:call)
            end
          end
        end
      end

      context 'when the transition lacks associated output' do
        before do
          the_interpreter.graph = graph_lacks_output
        end

        context 'but the transition is associated with an effector' do
          context "and that effector's arity is -1" do
            it 'will call that effector with nil' do
              the_interpreter.putm('stimulus')
  
              expect(an_effector).to have_received(:call).with(nil)
            end
          end
        end

        context 'and the transition is not associated with an effector' do
          before do
            the_interpreter.graph = graph_lacks_both_output_and_effector
          end

          context 'but the fallback effector has been defined' do
            before do
              the_interpreter.fallback_effector = the_fallback_effector
            end

            context 'and fallback_always is true (which it is by default)' do
              it 'will call the fallback effector' do
                the_interpreter.putm('stimulus')
  
                expect(the_fallback_effector).to have_received(:call)
              end
            end

            context 'and fallback_always is false' do
              before do
                the_interpreter.fallback_always = false
              end

              it 'will not call the fallback effector' do
                the_interpreter.putm('stimulus')
  
                expect(the_fallback_effector).not_to have_received(:call)
              end
            end
          end

          context 'but the fallback effector has ben defined with always=false' do
            before do
              the_interpreter.fallback_effector = the_fallback_effector, true
            end

            it 'will not call the fallback effector' do
              the_interpreter.putm('stimulus')

              expect(the_fallback_effector).not_to have_received(:call)
            end
          end
        end
      end
    end

    describe 'guarding against uncallable effectors' do
      let(:uncallable) do
        spy("uncallable").tap do |dbl|
          allow(dbl).to receive(:respond_to?).with(:call).and_return(false)
        end
      end

      context 'when a transition is associated with an uncallable effector' do
        before do
          the_interpreter.graph = {
            'origin' => {
              'stimulus' => {
                state: 'settlement',
                effector: uncallable,
              }
            }
          }
          the_interpreter.state = 'origin'
        end

        it 'will not call that effector' do
          the_interpreter.putm('stimulus')

          expect(uncallable).not_to have_received(:call)
        end
      end

      context 'when a transition is not associated with an effector, but has output' do
        before do
          the_interpreter.graph = {
            'origin' => {
              'stimulus' => {
                state: 'settlement',
                output: 'hello',
              }
            }
          }
          the_interpreter.state = 'origin'
        end

        context 'and the fallback effector is defined, but not callable' do
          before do
            the_interpreter.fallback_effector = uncallable
          end

          it 'will not call the fallback effector' do
            the_interpreter.putm('stimulus')

            expect(uncallable).not_to have_received(:call)
          end
        end
      end
    end
  end
end
