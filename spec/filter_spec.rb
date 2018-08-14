RSpec.describe Moory::Filter do
  let(:the_filter) do
    Moory::Filter.new(rules: our_rules)
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

  let(:the_quarantine) do
    spy('the quarantine')
  end

  describe 'the machine described by our_rules' do
    context 'in state "^"' do
      before do
        the_filter.state = '^'
      end

      context 'given the "p" stimulus,' do
        context 'if a consumer has been assigned,' do
          before do
            the_filter.consumer = the_consumer
          end

          it 'the consumer will be called with "p"' do
            the_filter.issue('p')
  
            expect(the_consumer).to have_received(:call).with('p')
          end
        end

        context 'if a consumer is missing' do
          before do
            the_filter.consumer = nil
          end

          it 'DEFAULT_CONSUMER will be called with "p"' do
            allow(Moory::Filter::DEFAULT_CONSUMER).to receive(:call)

            the_filter.issue('p')
  
            expect(Moory::Filter::DEFAULT_CONSUMER).to have_received(:call).with('p')
          end
        end
      end

      context 'given a stimulus unknown to this state,' do
        let(:unknown) { 'z' }

        context 'if a quarantine has been assigned,' do
          before do
            the_filter.quarantine = the_quarantine
          end

          it 'the quarantine will be called with the unknown character' do
            the_filter.issue(unknown)

            expect(the_quarantine).to have_received(:call).with(unknown)
          end
        end

        context 'if the quarantine is missing,' do
          before do
            the_filter.quarantine = nil
          end

          # it 'IGNORE_UNKNOWN will be called with the unknown character' do
          #   allow(Moory::Filter::IGNORE_UNKNOWN).to receive(:call)

          #   the_filter.issue(unknown)
  
          #   expect(Moory::Filter::IGNORE_UNKNOWN).to have_received(:call).with(unknown)
          # end
        end
      end
    end
  end
end
