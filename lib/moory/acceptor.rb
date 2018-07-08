module Moory
  module Acceptor
    def Acceptor.create(specification)
      Moory::Interpreter.new do |i|
        i.load(specification[:transitions])
        
        i.default_proc = proc { |msg| 
          raise "#{i} in state #{i.state} did not understand #{msg}.  Input rejected!"
        }
      
        define_singleton_method(:accepts?) do |string:, in_state: nil|
          i.state = in_state ? in_state : specification[:initial]
          
          string.each_char { |c| putm(c) }
      
          specification[:final].include?(i.state)
        end
      end
    end
  end
end
