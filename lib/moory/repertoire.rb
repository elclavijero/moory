module Moory
  class Repertoire
    SKIP = proc {}

    attr_reader :knowledge
    attr_reader :fallback
    attr_reader :always

    # Create a repertoire from a Hash mapping names to callable objects.
    #
    # @return [Repertoire]
    def Repertoire.from_hash(hash={})
      new.tap { |r| r.cram(hash) }
    end

    def initialize
      @fallback  = SKIP
      @always    = SKIP
      @knowledge = {}
    end

    # Learn multiple items of knowledge.
    def cram(hash={})
      hash.each { |k,v| learn(name: k, item: v) }
    end

    # Associate a name with a callable object.  The item will not be stored unless it is callable; 
    #   that is, it must respond to `:call`.
    #
    # @param item the callable object you want to store.
    # @param name the name you will use to identify the `item`.
    def learn(item:,name:)
      @knowledge.store(name, item) if (
        appropriate?(item) && name
      )
    end

    # Recall a callable object by name.
    #
    # @param the name identifying the object you want to retrieve.
    # @return if the given value represents knowledge, then that which has been learned is returned.
    #   If the name does not represent an item of knowledge, then the `fallback` is returned.  You will
    #   always get something callable when you call this method.
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
