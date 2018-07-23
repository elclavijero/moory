module Moory
  module Loader
    def Loader.load(rules:, machine:)
      prs = Moory::RuleParser::FileReader.new
      ary = prs.analyse(rules)
      ary.each do |params|
        machine.transitions.store(params)
      end
    end
  end
end
