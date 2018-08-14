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

      context 'providing a quarantine object has NOT been defined,' do
        before do
          the_unit.quarantine = nil
        end

        it 'the Unit will raise an exception' do
          expect{
            the_unit.issue(foreign_stimulus)
          }.to raise_error("Unexpected #{foreign_stimulus}")
        end
      end

      context 'providing a quarantine object has been defined' do
        before do
          the_unit.quarantine = the_quarantine
        end

        let(:the_quarantine) do
          spy('the qurantine')
        end

        it 'the Unit will call the quarantine with the foreign stimulus' do
          the_unit.issue(foreign_stimulus)

          expect(the_quarantine).to have_received(:call).with(foreign_stimulus)
        end
      end
    end
  end
end
