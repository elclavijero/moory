RSpec.describe Moory::RuleParser::Machine do
  let(:machine) do
    Moory::RuleParser::Machine.new
  end

  describe 'its interface' do
    it 'exposes #scan_data' do
      expect(machine).to respond_to(:scan_data)
    end

    it 'exposes #<<' do
      expect(machine).to respond_to(:<<)
    end

    it 'exposes #reset' do
      expect(machine).to respond_to(:reset)
    end
  end

  describe '#<<' do
    context 'having not yet been given any special characters,' do
      context 'given a succession of undistinuished characters' do
        before do
          undistinguished_succession.each_char { |c| machine << c }
        end

        let(:undistinguished_succession) { "no colons or forward slashes" }

        it 'will append those to #scan_data.origin' do
          expect(machine.scan_data.origin).to eq(undistinguished_succession)
        end
      end
    end
  end
end
