require 'set'

module Moory
  class Interpreter
    attr_accessor :graph, :effectors, :state
    attr_reader   :fallback_effector, :default_proc

    SKIP = proc {}
    WARN = proc { |msg| warn "Did not understand: #{msg}" }

    def initialize(graph={}, &block)
      @graph        = graph
      @effectors    = {}
      @default_proc = SKIP

      instance_eval &block if block_given?
    end

    def load(source)
      p = Moory::Parser.new
      @graph = p.analyse(source)
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
      graph[state].keys.to_set
    end

    def states
      @states ||= graph.keys.to_set
    end

    def alphabet
      @alphabet ||= Set.new(
        graph.each_value.collect { |m| m.keys }.flatten
      )
    end

    private

    def respond(msg)
      dispatch(msg)
      @state = graph[state][msg][:state]
    end

    def dispatch(msg)
      _effector, _output = effector(msg), output(msg)

      if _effector.respond_to?(:call)
        _effector.arity == 0 ?
          _effector.call :
          _effector.call(_output)
      end
    end

    def effector(msg)
      candidate = graph[state][msg][:effector]

      if candidate.kind_of?(String)
        effectors[candidate]
      else
        candidate || fallback_effector
      end
    end

    def output(msg)
      graph[state][msg][:output]
    end

    def bad_call(msg)
      default_proc.call(msg) if default_proc
    end
  end
end
