module Moory
  class Filter < Moory::Logistic::Unit
    attr_writer :consumer
    attr_writer :quarantine

    IGNORE = [' ', "\t", "\n"]
    DEFAULT_CONSUMER = $stdout.method(:puts)
    IGNORE_UNKNOWN   = proc { |c| pp "Warning! Ignoring unknown character: #{c}" }
  
    def initialize(rules:, consumer:DEFAULT_CONSUMER, quarantine:IGNORE_UNKNOWN)
      @buffer = ""
      @consumer   = consumer
      @quarantine = quarantine
      super(rules: rules)
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

    private

    def bad_stimulus(stimulus)
      quarantine.call(stimulus)
    end

    def consumer
      @consumer || DEFAULT_CONSUMER
    end

    def quarantine
      @quarantine || IGNORE_UNKNOWN
    end
  end
end
