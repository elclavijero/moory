module Moory
  class Parser
    attr_reader :graph, :staged
  
    def initialize
      @graph   = {}
      prime
    end
  
    def analyse(input)
      input.each_line do |line| 
        scan(line); store if valid?
        reset
      end

      graph
    end
  
    private
  
    def scan(string)
      string.chomp.each_char { |c| interpret(c) }
    end
  
    def interpret(char)
      if @interpreter.understand?(char)
        @interpreter.putm(char)
      else
        staged.fetch(@focus) { |k| staged[k] = '' } << char
      end
    end
  
    def store
      y = graph.fetch(staged['source']) { |k| graph[k] = {} }
      z = y.fetch(staged['stimulus'])    { |k| y[k] = {} }
      z.merge!({ 
        state:    staged['target'],
        output:   staged['output'],
        effector: staged['effector'] }
        .compact 
      )
    end
  
    def valid?
      staged['source']   && 
      staged['stimulus'] && 
      staged['target']
    end

    def interpreter
      @interpreter ||= Moory::Interpreter.new({
        '0' => {
          ':'  => { state: '1', effector: method(:stimulus) },
          ' '  => { state: '0' },
          '\t' => { state: '0' }
        },
        '1' => { 
          '/'  => { state: '2', effector: method(:output) },
          ':'  => { state: '4', effector: method(:target) },
          ' '  => { state: '1' },
          '\t' => { state: '1' }
        },
        '2' => {
          ':'  => { state: '4', effector: method(:target) },
          '/'  => { state: '3', effector: method(:effector) },
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
      })
    end

    %w{
      source stimulus target output effector
    }.each { |c| define_method(c) { @focus = c } }

    def prime
      interpreter.state = '0'
      @staged   = {}
      source
    end

    alias reset prime
  end
end
