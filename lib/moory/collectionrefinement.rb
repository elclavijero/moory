module Moory
  module CollectionRefinement
    module ArrayRefinement
      refine Array do
        def lift
          {} if empty?
        end
      end
    end

    module HashRefinement
      refine Hash do
        def then(other)
          {} if other.empty?
        end
      end
    end
  end
end
