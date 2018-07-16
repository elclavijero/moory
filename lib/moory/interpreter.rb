require 'set'

module Moory
  class Interpreter
    attr_accessor :transitions, :effectors, :state
    attr_reader   :fallback_effector, :default_proc

    SKIP = proc {}
    WARN = proc { |msg| warn "Did not understand: #{msg}" }

    def initialize(transitions: {}, effectors: {}, default_proc: SKIP, fallback_always: true, &block)
      @transitions  = transitions
      @effectors    = effectors
      @default_proc = default_proc
      @fallback_always = fallback_always

      instance_eval &block if block_given?
    end

    def load(source)
      p = Moory::Parser.new
      @transitions.merge!(p.analyse(source))
    end

    def fallback_effector=(obj)
      candidate = obj.kind_of?(String) ? effectors[obj] : obj
      
      @fallback_effector = candidate.respond_to?(:call) ? candidate : nil
    end

    def fallback_always=(bool)
      @fallback_always = bool
    end

    def default_proc=(obj)
      @default_proc = obj.respond_to?(:call) ? obj : nil
    end

    def putm(msg)
      warn """
      #{self} received #{msg} before being assigned a state.
      The message will be passed to the default_proc.
      """ unless state
      
      understand?(msg) ? respond(msg) : bad_call(msg)
    end

    def understand?(msg)
      receptors.include?(msg)
    end

    def receptors
      transitions.alphabet(restrict:state)
    end

    def states
      @states ||= transitions.states
    end

    def alphabet
      @alphabet ||= transitions.alphabet
    end

    private

    def respond(msg)
      dispatch(msg)
      resettle(msg)
    end

    def dispatch(msg)
      _effector, _output = effector(msg), output(msg)

      if _effector.respond_to?(:call)
        _effector.arity == 0 ?
          _effector.call :
          _effector.call(_output)
      end
    end

    def resettle(msg)
      @state = transitions.response(origin: state, stimulus: msg)[:settlement]
    end

    def effector(msg)
      candidate = transitions.response(origin: state, stimulus: msg)[:effector]

      if candidate.kind_of?(String)
        effectors[candidate]
      else
        candidate || (fallback_effector if fallback_appropriate_for?(msg))
      end
    end

    def fallback_appropriate_for?(msg)
      @fallback_always ? @fallback_always : output(msg)
    end

    def output(msg)
      transitions.response(origin: state, stimulus: msg)[:output]
    end

    def bad_call(msg)
      default_proc.call(msg) if default_proc
    end
  end
end
