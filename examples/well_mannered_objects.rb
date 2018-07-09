# Well-mannered objects

# Suppose we have an uncouth object 
uncouth = Object.new

# and it can speak
def uncouth.say_foo
  pp 'foo'
end
def uncouth.say_bar
  pp 'bar'
end
def uncouth.say_something_nice(name)
  pp "Hello, #{name}. You look nice."
end

# Do you see anything wrong here?
# Doesn't that object seem a little dangerous? Everybody knows that "foo" comes before "bar" in 
# code examples.  That absurd object might ruin everything! Is there anything we can do to prevent 
# it from doing the unthinkable?
# 
# uncouth.say_bar
# uncouth.say_foo
#

# Yes, of course there is!  We can filter calls to the uncouth object using Moory's WellManered 
# class.
require 'moory'

# We can go no further until we write down the rules of foo-bar-etiquette

the_rules_of_foo_bar_etiquette = """
  start        : say_foo  : said_foo
    
  said_foo     : say_foo  : said_foo
  said_foo     : say_bar  : said_foo_bar

  said_foo_bar : say_foo  : said_foo_bar
  said_foo_bar : say_bar  : said_foo_bar
"""

# Let's make a postive change, and hereon refer to the uncouth object as the `well_mannered_object`.
# It will be our `protege`, and the instantiation of a WellMannered object won't surprise us:

well_mannered_object = Moory::WellMannered.new(
  protege: uncouth,
  rules:   the_rules_of_foo_bar_etiquette
)

# Now let's have a conversation with our protege.
well_mannered_object.say_something_nice('Adam')
# That is nice.
well_mannered_object.say_bar    
# Good.  I'm glad you didn't fall for that
well_mannered_object.say_foo    
# Promising.  You haven't yet spoken out of turn.
well_mannered_object.say_foo
# A perfectly acceptable reptition.
well_mannered_object.say_bar
# Wonderful!
well_mannered_object.say_something_nice('Adam')
# Yes. Thank you.

# Clearly, our well mannered object is polite and highly cooperative.  If someone asks it 
# to depart from protocol, it will just quietly refuse.  But what if that isn't enough?
# What should it do if somone asks it to do something really bad?  The trouble is,
# well-mannered objects are so well-behaved, they won't do anything unless we say its OK.
# Let's do that.

well_mannered_object.reaction_to_unknown = proc { |msg|
  pp "You can't tell me to #{msg}! I'm telling!"
}

# Now when we ask it to do something it shouldn't
well_mannered_object.do_something_bad('now')

# it will tell on you.

# What a nice object!  Now don't be such a tell-tale
well_mannered_object.reaction_to_unknown = nil

