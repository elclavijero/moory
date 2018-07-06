module Moory
  class Parser
    attr_reader :config, :staged
  
    def initialize
      @config   = {}
      prime
    end
  
    def analyse(input)
      input.each_line { |line| scan(line)}
      config
    end
  
    private
  
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
  
    def prime
      interpreter.state = '0'
      source
      @staged   = {}
    end

    alias reset prime
  
    def scan(string)
      string.chomp.each_char do |c|
        putc(c)
      end
      store if valid?
      reset
    end
  
    def putc(char)
      if @interpreter.understand?(char)
        @interpreter.putm(char)
      else
        staged.fetch(@focus) { |k| staged[k] = '' } << char
      end
    end
  
    def store
      y = config.fetch(staged['source']) { |k| config[k] = {} }
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

    def source(*args)
      @focus = 'source'
    end

    def stimulus(*args)
      @focus = 'stimulus'
    end

    def output(*args)
      @focus = 'output'
    end

    def effector(*args)
      @focus = 'effector'
    end

    def target(*args)
      @focus = 'target'
    end
  end
end
