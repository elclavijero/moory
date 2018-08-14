module Moory
  class Filter < Moory::Logistic::Unit
    attr_writer :consumer

    IGNORE = [' ', "\t", "\n"]
    DEFAULT_CONSUMER = $stdout.method(:puts)
    IGNORE_FOREIGN   = proc { |c| pp "Warning! Ignoring unknown character: #{c}" }
  
    def initialize(rules:, consumer:DEFAULT_CONSUMER, quarantine:IGNORE_FOREIGN)
      @buffer = ""
      @consumer = consumer
      super(rules: rules, quarantine:quarantine)
    end
  
    def configure(rules)
      super
      repertoire.learn(name: 'produce', item: method(:produce))
    end
  
    def issue(stimulus)
      return if IGNORE.include?(stimulus)
      
      @buffer << stimulus
      super
    end

    def produce(output)
      consumer.call(@buffer)
      @buffer = ""
    end

    def consumer
      @consumer || DEFAULT_CONSUMER
    end
  end
end
