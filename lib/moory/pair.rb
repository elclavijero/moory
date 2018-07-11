module Moory
  Pair = Struct.new(:left, :right, keyword_init: true) do
    def valid?
      left && right
    end

    def shunt(value)
      { left => { right => value } }
    end
  end
end
