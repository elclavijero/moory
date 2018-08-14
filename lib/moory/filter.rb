module Moory
  class Filter < Moory::Logistic::Unit
    IGNORE = [' ', "\t", "\n"]
    DEFAULT_CONSUMER = $stdout.method(:puts)
    IGNORE_FOREIGN   = proc { |c| "Warning! Ignoring unknown character: #{c}" }
  
    def initialize(rules:, consumer:DEFAULT_CONSUMER, quarantine:IGNORE_FOREIGN)
      @buffer = ""
      @consumer = consumer
      @quarantine = quarantine
      super(rules: rules, quarantine:quarantine)
    end
  
    def configure(rules)
      super
      repertoire.learn(name: 'produce', item: method(:produce))
    end
  
    def produce(output)
      @consumer.call(
        @buffer 
      )
      @buffer = ""
    end
  
    def issue(stimulus)
      return if IGNORE.include?(stimulus)
      
      @buffer << stimulus
      super
    end
  end
end
