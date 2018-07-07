require 'moory'

silly = Moory::Interpreter.new do |i|
  i.load """
    0 : a / u / foo : 1
    0 : b / v / foo : 2
    1 : a / w / bar : 1
    1 : b / x / bar : 2
    2 : a / y /     : 1
    2 : b / z       : 2
  """
end

# Tell the interpreter where we want to start
silly.state = '0'

# Define some handlers for the effectors named in the 
# loaded specification.
silly.effectors = {
  'foo' => proc { |msg| pp "#{msg} says: fooby fooby foo" },
  'bar' => proc { |msg| pp "#{msg} says: barby barby bar" },
}

# Tell the interpreter the name of the effector we want to use
# if a transition has output, but no effector.
silly.fallback_effector = 'bar'


# Send the interpreter some messages: putm means "PUT Message"
silly.putm('b') # outputs: "v says: fooby fooby foo"
silly.putm('b') # outputs: "z says: barby barby bar"
silly.putm('a') # outputs: "y says: barby barby bar"
silly.putm('a') # outputs: "w says: barby barby bar"

