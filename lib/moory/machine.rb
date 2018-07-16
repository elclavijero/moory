module Moory
  class Machine
    attr_accessor :transitions
    extend Forwardable
    
    def_delegator :@transitions, :states
    def_delegator :@transitions, :alphabet
  end
end
