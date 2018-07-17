module Moory
  class Machine
    attr_accessor :transitions
    attr_accessor :repertoire
    attr_accessor :state

    extend Forwardable
    def_delegators :@transitions, :states, :alphabet

    def_delegators :@repertoire, :always=, :always
    def_delegators :@repertoire, :fallback=, :fallback

    def issue(stimulus)
      if response = transitions.response(origin: state, stimulus: stimulus)
        honour(response)
      end
    end

    alias putm issue

    def understand?(stimulus)
      transitions
        .alphabet(restrict: state)
        .include?(stimulus)
    end

    private

    def honour(response)
      perform(response) if repertoire

      settle_accordingly(response)
    end

    def perform(response)
      perform_always(response[:output])
      perform_special(response)
    end

    def settle_accordingly(response)
      @state = response[:settlement]
    end

    def perform_always(output)
      guarded_call(always, output)
    end

    def perform_special(response)
      guarded_call(
        repertoire.recall(response[:effector]),
        response[:output]
      ) if response[:effector]
    end

    def guarded_call(receiver, output)
      output ? receiver.call(output) : receiver.call
    end
  end
end
