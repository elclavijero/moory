RSpec.describe Moory::WellMannered do
  # Suppose we have an uncouth object 
  let(:uncouth) do
    spy("uncouth") # it can be asked to do anything
  end

  let(:the_rules) do
    """
      0 : say_foo  : 1

      2 : say_bar  : 2
    """
  end

  let(:where_to_start) do
    '0'
  end

  let(:well_mannered_object) do
    Moory::WellMannered.new(
      protege: uncouth,
      rules:   the_rules,
      initial: where_to_start,
    )
  end

  describe '#restricted_messages' do
    it 'will return the set of messages governed by the rules' do
      expect(
        well_mannered_object.restricted_messages
      ).to eq(
        %w{ say_foo say_bar }.to_set
      )
    end
  end

  describe 'sending messages corresponding to transitions in the rules' do
    context 'when sent a conformant message' do
      it 'will allow the message to pass through to the uncouth object' do
        well_mannered_object.say_foo

        expect(uncouth).to have_received(:say_foo)
      end
    end
  end
end
