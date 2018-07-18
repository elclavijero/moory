RSpec.describe Moory::RuleParser::Machine do
  let(:machine) do
    Moory::RuleParser::Machine.new
  end

  describe 'its interface' do
    it 'exposes #scan_data' do
      expect(machine).to respond_to(:scan_data)
    end

    it 'exposes #putc' do
      expect(machine).to respond_to(:putc)
    end

    it 'exposes #puts' do
      expect(machine).to respond_to(:puts)
    end

    it 'exposes #reset' do
      expect(machine).to respond_to(:reset)
    end
  end

  describe '#putc' do
    context 'having not yet been given any special characters,' do
      context 'given a succession of undistinuished characters' do
        before do
          undistinguished_succession.each_char { |c| machine.putc(c) }
        end

        let(:undistinguished_succession) { "no colons or forward slashes" }

        it 'will append those to #scan_data.origin' do
          expect(machine.scan_data.origin).to eq(undistinguished_succession)
        end
      end

      context 'given a special character,' do
        it 'will change #state' do
          expect {
            machine.putc(':')
          }.to change {
            machine.state
          }.to (
            'stimulus'
          )
        end
      end
    end
  end

  describe 'how strings are mapped to scan data' do
    before(:each) do
      machine.reset
    end

    context 'given the string: "0:a:1",' do
      let(:scan_data) do
        machine << "0:a:1"
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
        machine << "0:a/x:1"
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
          expect(scan_data.stimulus).to eq('a')
        end

        it 'will have nil for the remaining properties' do
          expect(scan_data.effector).to be_nil
        end
      end
    end
  end
end
