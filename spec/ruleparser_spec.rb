RSpec.describe Moory::RuleParser::LineReader do
  let(:line_reader) do
    Moory::RuleParser::LineReader.new
  end

  describe 'its interface' do
    it 'exposes #scan_data' do
      expect(line_reader).to respond_to(:scan_data)
    end

    it 'exposes #putc' do
      expect(line_reader).to respond_to(:putc)
    end

    it 'exposes #puts' do
      expect(line_reader).to respond_to(:puts)
    end

    it 'exposes #reset' do
      expect(line_reader).to respond_to(:reset)
    end
  end

  describe '#putc' do
    context 'having not yet been given any special characters,' do
      context 'given a succession of undistinuished characters' do
        before do
          undistinguished_succession.each_char { |c| line_reader.putc(c) }
        end

        let(:undistinguished_succession) { "no_colons_or_forward_slashes" }

        it 'will append those to #scan_data.origin' do
          expect(line_reader.scan_data.origin).to eq(undistinguished_succession)
        end
      end

      context 'given a special character,' do
        it 'will change #state' do
          expect {
            line_reader.putc(':')
          }.to change {
            line_reader.state
          }.to (
            'stimulus'
          )
        end
      end
    end
  end

  describe 'how strings are mapped to scan data' do
    before(:each) do
      line_reader.reset
    end

    context 'given the string: "0:a:1",' do
      let(:scan_data) do
        line_reader << "0:a:1"
      end
      
      describe 'the scan data returned' do
        it 'will have origin: "0"' do
          expect(scan_data.origin).to eq('0')
        end

        it 'will have stimulus: "a"' do
          expect(scan_data.stimulus).to eq('a')
        end

        it 'will have settlement: "1"'  do
          expect(scan_data.settlement).to eq('1')
        end

        it 'will have nil for the remaining properties' do
          expect(scan_data.output).to be_nil
          expect(scan_data.effector).to be_nil
        end
      end
    end

    context 'given the string: "0:a/x:1",' do
      let(:scan_data) do
        line_reader << "0:a/x:1"
      end
      
      describe 'the scan data returned' do
        it 'will have origin: "0"' do
          expect(scan_data.origin).to eq('0')
        end

        it 'will have stimulus: "a"' do
          expect(scan_data.stimulus).to eq('a')
        end

        it 'will have settlement: "1"'  do
          expect(scan_data.settlement).to eq('1')
        end

        it 'will have output: "x"' do
          expect(scan_data.output).to eq('x')
        end

        it 'will have nil for the remaining properties' do
          expect(scan_data.effector).to be_nil
        end
      end
    end

    context 'given the string: "0:a/x:1",' do
      let(:scan_data) do
        line_reader << "0:a/x/foo:1"
      end
      
      describe 'the scan data returned' do
        it 'will have origin: "0"' do
          expect(scan_data.origin).to eq('0')
        end

        it 'will have stimulus: "a"' do
          expect(scan_data.stimulus).to eq('a')
        end

        it 'will have settlement: "1"'  do
          expect(scan_data.settlement).to eq('1')
        end

        it 'will have output: "x"' do
          expect(scan_data.output).to eq('x')
        end

        it 'will have effector: "foo"' do
          expect(scan_data.effector).to eq('foo')
        end
      end
    end

    context 'given the string: "0  :  a/    x /foo  :    1    ",' do
      let(:scan_data) do
        line_reader << "0  :  a/    x /foo  :    1    "
      end
      
      describe 'the scan data returned' do
        it 'will have origin: "0"' do
          expect(scan_data.origin).to eq('0')
        end

        it 'will have stimulus: "a"' do
          expect(scan_data.stimulus).to eq('a')
        end

        it 'will have settlement: "1"'  do
          expect(scan_data.settlement).to eq('1')
        end

        it 'will have output: "x"' do
          expect(scan_data.output).to eq('x')
        end

        it 'will have effector: "foo"' do
          expect(scan_data.effector).to eq('foo')
        end
      end
    end
  end
end
