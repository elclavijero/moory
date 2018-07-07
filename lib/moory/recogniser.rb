module Moory
  module Recogniser
    def Recogniser.create(specification)
      Moory::Interpreter.new do |i|
        i.load(specification[:transitions])
      
        define_singleton_method(:accepts?) do |string|
          i.state = specification[:initial]
          
          string.each_char { |c| putm(c) }
      
          specification[:final].include?(i.state)
        end
      end
    end
  end
end
