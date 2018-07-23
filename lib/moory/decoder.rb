module Moory
  class Decoder
    include Efferent

    def initialize(rules:, initial:, ostream:$stdout)
      @initial = initial
      @state = initial
      @ostream = ostream
      configure(rules)
    end

    def configure(rules)
      Loader.load(rules: rules, machine: self)
      repertoire.always = method(:write)
    end

    def write(output=nil)
      @ostream.write(output) if output
    end

    def decode(string)
      string.each_char { |c| issue(c) }
    end
  end
end
