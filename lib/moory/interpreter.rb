module Moory
  class Interpreter
    attr_accessor :transition_relation
    extend Forwardable
    
    def_delegator :@transition_relation, :states
    def_delegator :@transition_relation, :alphabet
  end
end
