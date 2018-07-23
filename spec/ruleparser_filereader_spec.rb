RSpec.describe Moory::RuleParser::FileReader do
  let(:filereader) do
    Moory::RuleParser::FileReader.new
  end

  describe 'its interface' do
    it 'exposes #analyse' do
      expect(filereader).to respond_to(:analyse)
    end
  end

  describe 'how files are mapped to lists' do
    context 'given input consisting of lines of rules' do
      let(:input) do
%q{0 : a / yes / foo : 1
0 : b / no  / bar : 2
1 : a / no  / bar : 2
1 : b / yes / foo : 1
2 : a / no  / bar : 2
2 : b / no  / bar : 2}
      end

      let(:expected) do
        [
          {origin:"0", stimulus:"a", settlement:"1", output:"yes", effector:"foo"},
          {origin:"0", stimulus:"b", settlement:"2", output:"no",  effector:"bar"},
          {origin:"1", stimulus:"a", settlement:"2", output:"no",  effector:"bar"},
          {origin:"1", stimulus:"b", settlement:"1", output:"yes", effector:"foo"},
          {origin:"2", stimulus:"a", settlement:"2", output:"no",  effector:"bar"},
          {origin:"2", stimulus:"b", settlement:"2", output:"no",  effector:"bar"}
        ]
      end

      it 'will produce a list of Moory::Transition::Hashers' do
        expect(
          filereader.analyse(input)
        ).to eq(
          expected
        )
      end
    end
  end
end
