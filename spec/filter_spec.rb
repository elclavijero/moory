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

          it 'the buffer will not grow' do
            expect{
              the_filter.issue('p')
            }.not_to change {
              the_filter.buffer
            }
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

          it 'IGNORE_UNKNOWN will be called with the unknown character' do
            allow(Moory::Filter::IGNORE_UNKNOWN).to receive(:call)

            the_filter.issue(unknown)
  
            expect(Moory::Filter::IGNORE_UNKNOWN).to have_received(:call).with(unknown)
          end

          it 'the buffer will not grow' do
            expect{
              the_filter.issue(unknown)
            }.not_to change {
              the_filter.buffer
            }
          end
        end
      end

      describe 'issuing characters that are held by the buffer' do
        context 'in state "^"' do
          before do
            the_filter.state = '^'
          end

          context 'after issuing an "a"' do
            before do
              the_filter.issue('a')
            end

            it 'the buffer will be "a"' do
              expect(the_filter.buffer).to eq('a')
            end

            it 'the state will be "a"' do
              expect(the_filter.state).to eq('a')
            end
          end

          context 'after issuing "ab"' do
            before do
              the_filter.issue('a')
              the_filter.issue('b')
            end

            it 'the buffer will be "ab"' do
              expect(the_filter.buffer).to eq('ab')
            end

            it 'the state will be "a"' do
              expect(the_filter.state).to eq('ab')
            end
          end

          context 'after issuing "abc"' do
            before do
              the_filter.issue('a')
              the_filter.issue('b')
              the_filter.issue('c')
            end

            it 'the buffer will be ""' do
              expect(the_filter.buffer).to eq('')
            end

            it 'the state will be "^"' do
              expect(the_filter.state).to eq('^')
            end
          end
        end
      end
    end
  end
end
