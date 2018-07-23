module Moory
  class Decoder
    include Efferent

    def initialize(rules:, initial:, ostream:$stdout)
      @initial = initial
      @state = initial
      @ostream = ostream
      configure(rules)
    end

    # Decode a string according to the rules.  Writes the decoded string to the output 
    #   stream configured at initialisation (which is $stdout, by default).  Characters
    #   not belonging to the alphabet will be dropped.
    #
    # @param string [String] the string you wish to decode
    def decode(string)
      string.each_char { |c| issue(c) }
    end

    private

    def configure(rules)
      Loader.load(rules: rules, machine: self)
      repertoire.always = method(:write)
    end

    def write(output=nil)
      @ostream.write(output) if output
    end
  end
end
