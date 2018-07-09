require 'moory'

# Create an acceptor for the language described by ab*
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

# Check some strings
ab_star.accepts?(string: "ab")   # => true
ab_star.accepts?(string: "abbb") # => true
ab_star.accepts?(string: "aab")  # => false
ab_star.accepts?(string: "aba")  # => false

# Check a string against another strating state
ab_star.accepts?(string: "bbb", in_state: '1')
# => true

# Uncomment the next line, and you'll see a runtime error
# ab_star.accepts?(string: "bbc", in_state: '1')

# Assign a default_proc, whcih is called when the Acceptor 
# encounters a character not in its alphabet e.g. 'c'
ab_star.default_proc = proc { |msg| puts "I'm going to ignore that #{msg}" }

# Deliberately give the Acceptor a bad character.
ab_star.accepts?(string: "abcbb")
# I'm going to ignore that c
# => true

