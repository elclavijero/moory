require 'set'

module Moory
  class Interpreter
    attr_accessor :config, :effectors, :state
    attr_reader   :fallback_effector, :default_proc

    SKIP = proc {}
    WARN = proc { |msg| warn "Did not understand: #{msg}" }

    def initialize(config={}, &block)
      @config    = config
      @effectors = {}
      @default_proc = SKIP

      instance_eval &block if block_given?
    end

    def load(source)
      p = Moory::ConfigParser.new
      @config = p.analyse(source)
    end

    def fallback_effector=(obj)
      candidate = obj.kind_of?(String) ? effectors[obj] : obj
      
      @fallback_effector = candidate.respond_to?(:call) ? candidate : nil
    end

    def default_proc=(obj)
      @default_proc = obj.respond_to?(:call) ? obj : nil
    end

    def putms(*msgs)
      msgs.each { |msg| putm msg }
    end

    def putm(msg)
      understand?(msg) ? respond(msg) : bad_call(msg)
    end

    def understand?(msg)
      receptors.include?(msg)
    end

    def receptors
      config[state].keys.to_set
    end

    def states
      @states ||= config.keys.to_set
    end

    def alphabet
      @alphabet ||= Set.new(
        config.each_value.collect { |m| m.keys }.flatten
      )
    end
    private

    def respond(msg)
      dispatch(msg)
      @state = config[state][msg][:state]
    end

    def dispatch(msg)
      _effector, _output = effector(msg), output(msg)

      _effector.call(_output) if _effector.respond_to?(:call)
    end

    def effector(msg)
      candidate = config[state][msg][:effector]

      if candidate.kind_of?(String)
        effectors[candidate]
      else
        candidate || fallback_effector
      end
    end

    def output(msg)
      config[state][msg][:output]
    end

    def bad_call(msg)
      default_proc.call(msg) if default_proc
    end
  end
end
