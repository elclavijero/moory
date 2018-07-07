require 'moory'
require 'stringio'

ostream = StringIO.new

mealy = Moory::Decoder.create(
  initial: '0',
  transitions: %q{
    0 : a / a : 1
    0 : b / b : 2
    1 : a     : 1
    1 : b / b : 2
    2 : a / a : 1
    2 : b     : 2
  },
  ostream: ostream
)

mealy.decode("abbbbbbaaaabaabbba")

ostream.string # => "abababa"
