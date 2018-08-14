RSpec.describe Moory::Logistic::Unit do
  let(:the_unit) do
    Moory::Logistic::Unit.new(rules: rules)
  end

  let(:rules) do
    "0 : a : 1"
  end

  describe '#issue' do
    context 'given a foreign stimulus,' do
      let(:foreign_stimulus) do
        'blah'
      end

      it 'the Unit will raise an exception' do
        expect{
          the_unit.issue(foreign_stimulus)
        }.to raise_error("Unexpected #{foreign_stimulus}")
      end
    end
  end
end
