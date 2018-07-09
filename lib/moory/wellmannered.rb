module Moory
  class WellMannered
    attr_reader :response_to_rule_breaking

    IGNORE = proc {}

    def initialize(protege:, rules:, initial:'start', response_to_rule_breaking: IGNORE)
      @protege  = protege
      @rules    = rules
      @initial  = initial
      @response_to_rule_breaking = response_to_rule_breaking
      prepare
    end

    def restricted_messages
      interpreter.alphabet
    end

    def response_to_rule_breaking=(obj)
      @response_to_rule_breaking = obj.respond_to?(:call) ? obj : IGNORE
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
        response_to_rule_breaking.call(*args)
    end
  
    def forward(*args)
      @protege.send(*args)
    end
  end
end
