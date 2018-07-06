RSpec.describe Moory::Parser do
  let(:the_parser) do
    Moory::Parser.new
  end

  describe '#analyse' do
    describe 'analysing a line that represents a basic transition' do
      it 'will create a config representing the transition' do
        the_config = the_parser.analyse('origin : stimulus : settlement')

        expect(the_config).to eq({
          'origin' => { 'stimulus' => { state: 'settlement' } }
        })
      end
    end

    describe 'analysing a line that contains an output specifier' do
      let(:the_config) do
        the_parser.analyse('origin : stimulus / output : settlement ')
      end

      it 'will create a config representing the transition and the output' do
        expect(the_config).to eq(
          'origin' => { 'stimulus' => { state: 'settlement', output: 'output' } }
        )
      end

      it 'will ignore empty output' do
        has_empty_output = "origin : stimulus / : settlement"

        expect(the_parser.analyse(has_empty_output)).to eq({
          'origin' => { 'stimulus' => { state: 'settlement' } }
        })
      end
    end

    describe 'analysing a line that contains an effector specifier' do
      let(:the_config) do
        the_parser.analyse('origin : stimulus /  / foo : settlement ')
      end

      it 'will create a config representing the transition, and effector' do
        expect(the_config).to eq(
          'origin' => { 
            'stimulus' => 
            { 
              state: 'settlement',
              effector: 'foo'
            } 
          }
        )
      end

      it 'will ignore an empty effector' do
        has_empty_output = "origin : stimulus / / : settlement"

        expect(the_parser.analyse(has_empty_output)).to eq({
          'origin' => { 'stimulus' => { state: 'settlement' } }
        })
      end
    end

    describe 'analysing a line of invalid input' do
      it 'a line with nothing after the second colon will not contribute to the config' do
        invalid = 'origin : stimulus: '
        expect(the_parser.analyse(invalid)).to eq({})
      end

      it 'a line with nothing between the first and second colons will not contribute to the config' do
        invalid = 'origin: :settlement'
        expect(the_parser.analyse(invalid)).to eq({})
      end

      it 'line with nothing before the first colon will not contribute to the config' do
        invalid = ' : stimulus : settlement '
        expect(the_parser.analyse(invalid)).to eq({})
      end
    end

    describe 'analysing mutltiple lines' do
      describe 'specifying duplicate transitions' do
        it 'duplicates are not evident in the config' do
          input = """
          origin : stimulus / output : settlement
          origin : stimulus / output : settlement
          """

          expect(the_parser.analyse(input)).to eq({
            'origin' => { 'stimulus' => { state: 'settlement', output: 'output' } }
          })
        end
      end

      describe 'overwriting a transition' do
        it 'the definition that appears latest in the input wins' do
          input = """
          origin : stimulus / output : rest
          origin : stimulus / output : settlement
          """

          expect(the_parser.analyse(input)).to eq({
            'origin' => { 'stimulus' => { state: 'settlement', output: 'output' } }
          })
        end
      end

      describe 'overwriting an output' do
        it 'the definition that appears latest in the input wins' do
          input = """
          origin : stimulus / blah   : settlement
          origin : stimulus / output : settlement
          """

          expect(the_parser.analyse(input)).to eq({
            'origin' => { 'stimulus' => { state: 'settlement', output: 'output' } }
          })
        end
      end
    end
  end
end
