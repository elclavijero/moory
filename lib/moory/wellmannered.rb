module Moory
  class WellMannered
    attr_reader :reaction_to_unknown

    IGNORE = proc {}

    def initialize(protege:, rules:, initial:'start', reaction_to_unknown: IGNORE)
      @protege  = protege
      @rules    = rules
      @initial  = initial
      @reaction_to_unknown = reaction_to_unknown
      prepare
    end

    def restricted_messages
      interpreter.alphabet
    end

    def reaction_to_unknown=(obj)
      @reaction_to_unknown = obj.respond_to?(:call) ? obj : IGNORE
    end
  
    private
  
    def prepare
      interpreter.load(@rules)
      interpreter.state = @initial
    end
  
    def interpreter
      @interpreter ||= Moory::Interpreter.new
    end
  
    def method_missing(*args)
      protected?(*args) ? 
        filter_first(*args) : 
        forward(*args)
    end
  
    def protected?(*args)
      interpreter.alphabet.include?(args.first.to_s)
    end
  
    def filter_first(*args)
      interpreter.putm(args.first.to_s) ? 
        forward(*args) : 
        reaction_to_unknown.call(msg)
    end
  
    def forward(*args)
      @protege.respond_to?(*args) ?
        @protege.send(*args) :
        reaction_to_unknown.call(*args)
    end
  end
end
