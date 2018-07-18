RSpec.describe Moory::RuleParser::LineReader do
  let(:line_reader) do
    Moory::RuleParser::LineReader.new
  end

  describe 'its interface' do
    it 'exposes #scan_data' do
      expect(line_reader).to respond_to(:scan_data)
    end

    it 'exposes #<<' do
      expect(line_reader).to respond_to(:<<)
    end

    it 'exposes #reset' do
      expect(line_reader).to respond_to(:reset)
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
