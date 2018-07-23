require 'set'

module Moory
  module Transition
    # Serves as a transition relation.
    class Storage
      def count
        storage.size
      end
      
      # Store a transition described by a hash
      #
      # @param params [Hash] a hash describing a transition.  At a minimum,
      #   it should include `:origin`, `:stimulus`, and `:settlement`.  
      #   It may also include `:output` and `:effector`.
      def store(params)
        storage.merge!(Hasher.new(params)) do |key, oldval, newval|
          oldval.merge!(newval)
        end
      end

      # Retrieve the unique response to a stimulus from a given origin.
      #
      # @return [Hash, nil] if the given parameters represent a transition, a Hash is returned
      #   including at least a `:settlement`, and maybe one/both of `:output` and `:effector`.
      #   If the paremeters do not correspond to a uniqu transition, `nil` is returned.
      def response(origin:, stimulus:)
        storage.dig(origin, stimulus)
      end

      # Retrieve the states represented by the transition relation.
      #
      # @return [Set]
      def states
        storage
          .keys
          .to_set
      end

      # Retrieve the alphabet
      #
      # @param restrict retricts the alphabet to that subset applicable to the state named by 
      #   the given value.
      # @return [Set]
      def alphabet(restrict:nil)
        storage
          .select  { |k| restrict ? k == restrict : true }
          .values
          .collect { |r| r.keys }
          .flatten
          .to_set
      end

      # Retrieve the egresses for the given state.
      #
      # @param state identifies the state for which egresses are being sought.
      # @return [Set]
      def egresses(state:)
        alphabet(restrict: state)
      end

      # Returns the transition relation.
      #
      # @return [Hash] represents the transition relation as a mapping from 
      #   (state, stimulus) to (settlement, output, effector).
      def storage
        @storage ||= {}
      end
    end

    # Helps expand a flat-hash description of a transition into a form
    # amenable to storage.
    Hasher = Struct.new(
      :origin,
      :stimulus,
      :settlement,
      :output,
      :effector, 
      keyword_init: true
    ) do

      def valid?
        origin && stimulus && settlement
      end

      def to_hash(for_storage: true)
        return {} unless valid?

        for_storage ?  storage_hash : flat_hash
      end

      private

      def storage_hash
        p = Pair.new(left: origin, right: stimulus)

        p.shunt({ 
          settlement: settlement,
          output:     output,
          effector:   effector
        }.compact)
      end

      def flat_hash
        {
          origin: origin,
          stimulus: stimulus,
          settlement: settlement,
          output: output,
          effector: effector
        }
      end
    end
  end
end
