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
      perform_for(response)

      move_according_to(response)
    end

    def perform_for(response)
      call_always(response[:output]) if repertoire
    end

    def call_always(output)
      guarded_call(always, output)
    end

    def move_according_to(response)
      @state = response[:settlement]
    end

    def guarded_call(receiver, output)
      output ? receiver.call(output) : receiver.call
    end
  end
end
