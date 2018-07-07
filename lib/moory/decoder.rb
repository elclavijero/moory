module Moory
  module Decoder
    def Mealy.create(config)
      Interpreter.new do |i|
        i.load(config[:transitions])
      
        define_singleton_method(:decode) do |string|
          i.state = config[:initial]
          i.fallback_effector = config
            .fetch(:ostream, $stdout)
            .method(:write)
      
          string.each_char do |c|
            i.putm(c)
          end
        end
      end
    end
  end
end
