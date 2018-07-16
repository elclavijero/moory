module Moory
  class Machine
    attr_accessor :transitions
    attr_accessor :repertoire
    attr_accessor :state
    extend Forwardable
    
    def_delegator :@transitions, :states
    def_delegator :@transitions, :alphabet

    def_delegator :@repertoire, :always=

    def understand?(msg)
      transitions
        .alphabet(restrict: state)
        .include?(msg)
    end
  end
end
