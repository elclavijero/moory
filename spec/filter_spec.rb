RSpec.describe Moory::Filter do
  let(:the_filter) do
    Moory::Filter.new(rules: our_rules, consumer: the_consumer)
  end

  let(:our_rules) do
    """
    ^  : p / p / produce : ^

    ^  : a : a
    a  : b : ab
    ab : c / abc / produce : ^
    """
  end

  let(:the_consumer) do
    spy('the consumer')
  end

  describe 'the machine described by our_rules' do
    context 'in state "^"' do
      before do
        the_filter.state = '^'
      end

      context 'given the "p" stimulus' do
        it 'will output "p"' do
          the_filter.issue('p')

          expect(the_consumer).to have_received(:call).with('p')
        end
      end
    end
  end
end
