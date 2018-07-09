module Moory
  class WellMannered
    def initialize(protege:, convention:)
      @protege    = protege
      @convention = convention
      prepare(convention)
    end
  
    private
  
    def prepare(rules:, initial:)
      interpreter.load(rules)
      interpreter.state = initial
    end
  
    def interpreter
      @interpreter ||= Moory::Interpreter.new
    end
  
    def method_missing(*args)
      protected?(*args) ? filter_first(*args) : forward(*args)
    end
  
    def protected?(*args)
      interpreter.alphabet.include?(args.first.to_s)
    end
  
    def filter_first(*args)
      interpreter.putm(args.first.to_s) ? forward(*args) : nil
    end
  
    def forward(*args)
      @protege.send(*args)
    end
  end
end
