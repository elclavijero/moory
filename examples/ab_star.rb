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

rcg.accepts?("a")   # => true
rcg.accepts?("b")   # => false
rcg.accepts?("c")   # => false
rcg.accepts?("ab")  # => true
rcg.accepts?("ac")  # => false
rcg.accepts?("abb") # => true
rcg.accepts?("abc") # => false
