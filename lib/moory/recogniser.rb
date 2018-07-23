module Moory
  class Recogniser
    include Afferent
    
    def initialize(rules:, initial:, final:)
      @initial = initial
      @final   = final
      Loader.load(rules: rules, machine: self)
    end
    
    # Answers whether the given string is accepted; that is, does it belong to
    # the language described by the rules?
    #
    # @param string [String] the candidate string.
    # @return [Boolean] true if the string is accepted; false, otherwise.
    def accepts?(string)
      reset

      string.each_char.all? { |c| issue(c) } && accepting?
    end

    private

    def reset
      @state = @initial
    end

    def accepting?
      @final.include?(state)
    end
  end
end
