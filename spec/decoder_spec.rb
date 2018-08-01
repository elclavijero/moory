RSpec.describe Moory::Decoder do
  let(:the_decoder) do
    Moory::Decoder.new(
      rules: %q{
        0 : a / a : 1
        0 : b / b : 2
        1 : a     : 1
        1 : b / b : 2
        2 : a / a : 1
        2 : b     : 2
      },
      initial: '0'
    )
  end

  describe 'some decoded strings' do
    context "decoding strings built from the decoder's alphabet (i.e. 'a', 'b')" do
      it "'a' will be decoded as 'a'" do
        expect{the_decoder.decode('a')}.to output('a').to_stdout
      end

      it "'ab' will be decoded as 'ab'" do
        expect{the_decoder.decode('ab')}.to output('ab').to_stdout
      end


      it "'aa' will be decoded as 'a'" do
        expect{the_decoder.decode('aa')}.to output('a').to_stdout
      end


      it "'bb' will be decoded as 'b'" do
        expect{the_decoder.decode('bb')}.to output('b').to_stdout
      end


      it "'aaaabbbaaabb' will be decoded as 'abab'" do
        expect{the_decoder.decode('aaaabbbaaabb')}.to output('abab').to_stdout
      end
    end
    
    context "including characters outside the decoder's alphabet (e.g. 'c')" do
      it 'will drop the foreign characters' do
        expect{the_decoder.decode('abcacb')}.to output('abab').to_stdout
      end
    end
  end
end
