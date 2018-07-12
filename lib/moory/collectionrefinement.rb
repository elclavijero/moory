module Moory
  module CollectionRefinement
    module ArrayRefinement
      refine Array do
        def map_to(other)
          Hash[*self.zip(other).flatten]
        end

        def lift
          map_to(self)
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
