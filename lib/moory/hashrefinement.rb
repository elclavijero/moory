module Moory
  module HashRefinement
    refine Hash do
      def then(other)
        {} if other.empty?
      end
    end
  end
end
