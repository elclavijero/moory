require 'moory/pair'

module Moory
  class Parser
    attr_reader :graph, :staged
  
    def initialize
      @graph   = {}
      prime_interpreter
    end
  
    def analyse(input)
      input.each_line do |line| 
        scan(line); store if valid?
        reset_interpreter
      end

      return graph
    end
  
    private
  
    def scan(string)
      string.chomp.each_char { |c| route(c) }
    end
  
    def route(char)
      special?(char) ? interpret(char) : write_to_focus(char)
    end

    def special?(char)
      interpreter.understand?(char)
    end

    def write_to_focus(char)
      staged.fetch(@focus) { |k| staged[k] = '' } << char
    end

    def interpret(char)
      interpreter.putm(char)
    end
  
    def store
      graph.merge!(transition)
    end

    def transition
      poise.shunt(response)
    end

    def poise
      Moory::Pair.new(left: staged['source'], right: staged['stimulus'])
    end

    def response
      { 
        state:    staged['target'],
        output:   staged['output'],
        effector: staged['effector']
      }.compact
    end
  
    def valid?
      staged['source']   && 
      staged['stimulus'] && 
      staged['target']
    end

    def prime_interpreter
      interpreter.state = '0'
      @staged   = {}
      source
    end

    alias reset_interpreter prime_interpreter

    def interpreter
      @interpreter ||= Moory::Interpreter.new(config)
    end

    def config
      {
        graph: {
          '0' => {
            ':'  => { state: '1', effector: 'stimulus' },
            ' '  => { state: '0' },
            '\t' => { state: '0' }
          },
          '1' => { 
            '/'  => { state: '2', effector: 'output' },
            ':'  => { state: '4', effector: 'target' },
            ' '  => { state: '1' },
            '\t' => { state: '1' }
          },
          '2' => {
            ':'  => { state: '4', effector: 'target' },
            '/'  => { state: '3', effector: 'effector' },
            ' '  => { state: '2' },
            '\t' => { state: '2' }
          },
          '3' => {
            ':'  => { state: '4', effector: method(:target) },
            ' '  => { state: '2' },
            '\t' => { state: '2' }
          },
          '4' => {
            ' '  => { state: '4' },
            '\t' => { state: '4' }
          }
        },
        effectors: {
            'stimulus' => method(:stimulus),
            'output'   => method(:output),
            'target'   => method(:target),
            'effector' => method(:effector),
        }
      }
    end

    %w{
      source stimulus target output effector
    }.each { |c| define_method(c) { @focus = c } }
  end
end
