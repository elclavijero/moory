require 'moory'

ab_star = Moory::Acceptor.create(
  initial: '0',
  transitions: %q{
    0 : a : 1
    0 : b : 2
    1 : a : 2
    1 : b : 1
    2 : a : 2
    2 : b : 2
  },
  final: %w{ 1 }
)


ab_star.accepts?(string: "abb")      
# => true
ab_star.accepts?(string:"abb", in_state: '1')
# => false
