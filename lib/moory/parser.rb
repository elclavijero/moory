require 'moory/pair'

module Moory
  class Parser
    attr_reader :transitions, :staged
  
    def initialize
      @transitions = Transition::Storage.new
      prime_interpreter
    end
  
    def analyse(input)
      input.each_line do |line| 
        scan(line); store
        reset_interpreter
      end

      return transitions.storage
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
      transitions.store(staged)
    end

    def prime_interpreter
      interpreter.state = '0'
      @staged   = {}
      origin
    end

    alias reset_interpreter prime_interpreter

    def interpreter
      @interpreter ||= Moory::Interpreter.new(config)
    end

    def config
      {
        transitions: {
          '0' => {
            ':'  => { state: '1', effector: 'stimulus' },
            ' '  => { state: '0' },
            '\t' => { state: '0' }
          },
          '1' => { 
            '/'  => { state: '2', effector: 'output' },
            ':'  => { state: '4', effector: 'settlement' },
            ' '  => { state: '1' },
            '\t' => { state: '1' }
          },
          '2' => {
            ':'  => { state: '4', effector: 'settlement' },
            '/'  => { state: '3', effector: 'effector' },
            ' '  => { state: '2' },
            '\t' => { state: '2' }
          },
          '3' => {
            ':'  => { state: '4', effector: method(:settlement) },
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
            'settlement'   => method(:settlement),
            'effector' => method(:effector),
        }
      }
    end

    %w{
      origin stimulus settlement output effector
    }.each { |c| define_method(c) { @focus = c } }
  end
end
