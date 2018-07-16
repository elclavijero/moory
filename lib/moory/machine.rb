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
      if response = transitions.response(origin: state, stimulus: stimulus)
        honour(response)
      end
    end

    def understand?(stimulus)
      transitions
        .alphabet(restrict: state)
        .include?(stimulus)
    end

    def honour(response)
      call_always(response[:output])

      move_according_to(response)
    end

    def call_always(output)
      output ? repertoire.always.call(output) : repertoire.always.call
    end

    def move_according_to(response)
      @state = response[:settlement]
    end
  end
end
