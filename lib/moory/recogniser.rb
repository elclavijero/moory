module Moory
  class Recogniser
    include Afferent
    
    def initialize(rules:, initial:, final:)
      @initial = initial
      @final   = final
      Loader.load(rules: rules, machine: self)
    end
    
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
