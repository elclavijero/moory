module Moory
  module Refinement
    module ArrayRefinement
      refine Array do
        def map_to(other)
          Hash[*self.zip(other).flatten].compact
        end

        def identity_map
          map_to(self)
        end
      end
    end

    module HashRefinement
      refine Hash do
        using ArrayRefinement
        def domain
          keys.to_set
        end

        def range
          values.to_set
        end

        def composable?(other)
          !(range & other.domain).empty?
        end

        def then(other)
          return {} if other.empty?
          transform_values { |v| other[v] }.compact
        end

        def project(*args)
          args.identity_map.then(self)
        end
      end
    end
  end
end
