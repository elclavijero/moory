require 'moory'

# Rules given in plain-text by the user 
ab_star_rules = %q{
  0 : a : 1
  0 : b : 2
  1 : a : 2
  1 : b : 1
  2 : a : 2
  2 : b : 2
}

# Create a Machine
mch = Moory::Machine.new

Moory::Loader.load(rules: ab_star_rules, machine: mch)

# Assign the machine state
mch.state = '0'

# after which we can issue messages
mch.issue('a')
mch.issue('a')

pp mch
