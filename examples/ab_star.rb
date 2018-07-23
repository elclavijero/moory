require 'moory'

rcg = Moory::Recogniser.new(
  initial: '0',
  rules: %q{
    0 : a : 1
    0 : b : 2
    1 : a : 2
    1 : b : 1
    2 : a : 2
    2 : b : 2
  },
  final:  [
    '1'
  ]
)

pp rcg.accepts?("a")   # => true
pp rcg.accepts?("b")   # => false
pp rcg.accepts?("c")   # => false
pp rcg.accepts?("ab")  # => true
pp rcg.accepts?("ac")  # => false
pp rcg.accepts?("abb") # => true
pp rcg.accepts?("abc") # => false
