RSpec.describe Moory::RuleParser::FileReader do
  let(:filereader) do
    Moory::RuleParser::FileReader.new
  end

  describe 'its interface' do
    it 'exposes #analyse' do
      expect(filereader).to respond_to(:analyse)
    end
  end
end
