RSpec.describe Moory::RuleParser::Machine do
  let(:machine) do
    Moory::RuleParser::Machine.new
  end

  describe 'its interface' do
    it 'exposes #focus' do
      expect(machine).to respond_to(:focus)
    end

    it 'exposes #scan_data' do
      expect(machine).to respond_to(:scan_data)
    end

    it 'exposes #<<' do
      expect(machine).to respond_to(:<<)
    end

    it 'exposes #prepare' do
      expect(machine).to respond_to(:prepare)
    end

    it 'exposes #reset' do
      expect(machine).to respond_to(:reset)
    end
  end
end
