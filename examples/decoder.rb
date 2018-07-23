require 'moory'

module Moory
  class Decoder < Transducer
    def initialize(rules:, initial:)
      super()
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

rules = %q{
  0 : a / a : 1
  0 : b / b : 2
  1 : a     : 1
  1 : b / b : 2
  2 : a / a : 1
  2 : b     : 2
}

decoder = Moory::Decoder.new(
  rules: rules,
  initial: '0'
)

decoder.decode("abababababbabbabaa")
