require 'moory'

decoder = Moory::Decoder.new(
  rules: %q{
    0 : a / a : 1
    0 : b / b : 2
    1 : a     : 1
    1 : b / b : 2
    2 : a / a : 1
    2 : b     : 2
  },
  initial: '0'
)

decoder.decode("abababababbabbabaa")
