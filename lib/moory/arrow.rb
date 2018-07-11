module Moory
  Arrow = Struct.new(
    :source,
    :label,
    :target,
    keyword_init: true
  ) do
    def valid?
      source && label && target
    end
  end
end
