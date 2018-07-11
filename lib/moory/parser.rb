require 'moory/arrow'
require 'moory/pair'

module Moory
  class Parser
    attr_reader :map, :graph, :staged
  
    def initialize
      @graph   = {}
      @map     = {}
      prime
    end
  
    def analyse(input)
      input.each_line do |line| 
        scan(line); store if valid?
        reset
      end

      return graph
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
      pair = Moory::Pair.new(left: staged['source'], right: staged['stimulus'])
      response = { 
        state:    staged['target'],
        output:   staged['output'],
        effector: staged['effector']
      }.compact

      map.store(pair, response)

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

    def prime
      interpreter.state = '0'
      @staged   = {}
      source
    end

    alias reset prime

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
