module Moory
  class Repertoire
    SKIP = proc {}

    attr_reader :knowledge, :fallback, :always

    def Repertoire.from_hash(hash={})
      new.tap { |r| r.cram(hash) }
    end

    def initialize
      @fallback  = SKIP
      @always    = SKIP
      @knowledge = {}
    end

    def cram(hash={})
      hash.each { |k,v| learn(name: k, item: v) }
    end

    def learn(item:,name:)
      @knowledge.store(name, item) if (
        appropriate?(item) && name
      )
    end

    def recall(name)
      name ? 
        knowledge.fetch(name, fallback) : 
        fallback
    end

    def fallback=(obj)
      @fallback = censor(obj)
    end

    def always=(obj)
      @always = censor(obj)
    end

    private

    def appropriate?(obj)
      obj.respond_to?(:call)
    end

    def censor(obj)
      appropriate?(obj) ? obj : SKIP
    end
  end
end
