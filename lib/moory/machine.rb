require 'forwardable'

module Moory
  module Efferent
    attr_accessor :transitions
    attr_accessor :repertoire
    attr_accessor :state

    extend Forwardable
    def_delegators :@transitions, :states, :alphabet

    def_delegators :@repertoire, :always=, :always
    def_delegators :@repertoire, :fallback=, :fallback

    def transitions
      @transitions ||= Moory::Transition::Storage.new
    end

    def repertoire
      @repertoire ||= Moory::Repertoire.new
    end

    def issue(stimulus)
      if response = transitions.response(origin: state, stimulus: stimulus)
        honour(response)
      end
    end

    alias putm issue

    def awaits
      transitions.egresses(state:state)
    end

    def understand?(stimulus)
      awaits.include?(stimulus)
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

  class Machine
    include Efferent
  end
end
