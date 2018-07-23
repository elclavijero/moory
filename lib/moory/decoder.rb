module Moory
  class Decoder
    include Efferent

    def initialize(rules:, initial:)
      @initial = initial
      @state = initial
      configure(rules)
    end

    def configure(rules)
      Loader.load(rules: rules, machine: self)
      repertoire.always = method(:write)
    end

    def write(output=nil)
      $stdout.write(output) if output
    end

    def decode(string)
      string.each_char do |c|
        issue(c)
      end
    end
  end
end
