require 'moory'

module Moory
  class Recogniser < Machine
    def initialize(rules:, initial:, final:)
      super()
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

rcg = Moory::Recogniser.new(
  rules: %q{
    0 : a : 1
    0 : b : 2
    1 : a : 2
    1 : b : 1
    2 : a : 2
    2 : b : 2
  },
  initial: '0',
  final:  [
    '1'
  ]
)

pp rcg.accepts?("a") == true
pp rcg.accepts?("b") == false
pp rcg.accepts?("c") == false
pp rcg.accepts?("ab") == true
pp rcg.accepts?("ac") == false
pp rcg.accepts?("abb") == true
pp rcg.accepts?("abc") == false