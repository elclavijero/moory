require 'forwardable'

module Moory
  module Afferent
    attr_accessor :transitions
    attr_accessor :state

    extend Forwardable
    def_delegators :@transitions, :states, :alphabet

    def transitions
      @transitions ||= Moory::Transition::Storage.new
    end

    # Issue a stimulus to the machine.
    #
    # @return will either be the new `settlement`, or `nil` if the stimulus is not understood.
    def issue(stimulus)
      if response = transitions.response(origin: state, stimulus: stimulus)
        honour(response)
      end
    end

    # Reveals the stimuli to which the machine may respond in its current state.
    #
    # @return [Set] 
    def awaits
      transitions.egresses(state:state)
    end

    # Answers whether a machine can respond to the given stimlus in its current state.
    #
    # @return [Boolean]
    def understand?(stimulus)
      awaits.include?(stimulus)
    end

    private

    def settle_accordingly(response)
      @state = response[:settlement]
    end

    def honour(response)
      settle_accordingly(response)
    end
  end

  module Efferent
    include Afferent

    attr_accessor :repertoire

    extend Forwardable
    def_delegators :@repertoire, :always=, :always
    def_delegators :@repertoire, :fallback=, :fallback

    def repertoire
      @repertoire ||= Moory::Repertoire.new
    end

    private

    def honour(response)
      super
      perform(response) if repertoire
    end

    def perform(response)
      perform_always(response[:output])
      perform_special(response)
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

  class Transducer
    include Efferent
  end
end
