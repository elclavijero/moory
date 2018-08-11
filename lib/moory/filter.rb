module Moory
  class Filter < Moory::Logistic::Unit
    IGNORE = [' ', "\t", "\n"]
    DEFAULT_CONSUMER = $stdout.method(:puts)
  
    def initialize(rules:, consumer:DEFAULT_CONSUMER)
      @buffer = ""
      @consumer = consumer
      super(rules: rules)
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
