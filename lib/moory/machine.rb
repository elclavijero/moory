module Moory
  class Machine
    attr_accessor :transitions
    attr_accessor :repertoire
    attr_accessor :state
    extend Forwardable
    
    def_delegator :@transitions, :states
    def_delegator :@transitions, :alphabet

    def_delegator :@repertoire, :always=
    def_delegator :@repertoire, :fallback=

    def putm(stimulus)
      response = transitions.response(origin: state, stimulus: stimulus)

      repertoire.always.call if response
      move_according_to(response) if response
    end

    def understand?(stimulus)
      transitions
        .alphabet(restrict: state)
        .include?(stimulus)
    end

    def move_according_to(response)
      @state = response[:settlement]
    end
  end
end
