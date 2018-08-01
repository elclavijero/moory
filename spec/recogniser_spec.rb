RSpec.describe Moory::Recogniser do
  let(:the_recogniser) do
    Moory::Recogniser.new(
      initial: '0',
      rules: %q{
        0 : a : 1
        0 : b : 2
        1 : a : 2
        1 : b : 1
        2 : a : 2
        2 : b : 2
      },
      final:  [
        '1'
      ]
    )
  end

  describe 'some acceptable inputs' do
    it 'accepts "a"' do
      expect(the_recogniser.accepts?("a")).to be
    end

    it 'accepts "ab"' do
      expect(the_recogniser.accepts?("ab")).to be
    end

    it 'accepts "abb"' do
      expect(the_recogniser.accepts?("abb")).to be
    end
  end
  
  describe 'some rejected inputs' do
    it 'rejects "b"' do
      expect(the_recogniser.accepts?("b")).not_to be
    end
  
    it 'rejects "c"' do
      expect(the_recogniser.accepts?("c")).not_to be
    end
  
    it 'rejects "ac"' do
      expect(the_recogniser.accepts?("ac")).not_to be
    end
  
    it 'rejects "abc' do
      expect(the_recogniser.accepts?("abc")).not_to be
    end
  end
end
