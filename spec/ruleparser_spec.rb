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
      context 'given an undistinguished character' do
        let(:undistinguished_character) { '0' }

        it 'will append the character to #scan_data.origin' do
          expect {
            machine << undistinguished_character
          }.to change {
            machine.scan_data.origin
          }.to (
            undistinguished_character
          )
        end
      end
    end
  end
end
