module Moory
  module Transition
    class Storage
      def count
        storage.size
      end
      
      def store(params)
        storage.merge!(Hasher.new(params)) do |key, oldval, newval|
          oldval.merge!(newval)
        end
      end

      def response(origin:, stimulus:)
        storage.dig(origin, stimulus)
      end

      def states
        storage
          .keys
          .to_set
      end

      def alphabet(restrict:nil)
        storage
          .select  { |k| restrict ? k == restrict : true }
          .values
          .collect { |r| r.keys }
          .flatten
          .to_set
      end

      def egresses(state:)
        alphabet(restrict: state)
      end

      def storage
        @storage ||= {}
      end
    end

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

      def to_hash(format: :for_storage)
        return {} unless valid?

        format == :for_storage ? 
          for_storage :
          flat_record
      end

      private

      def for_storage
        p = Pair.new(left: origin, right: stimulus)

        p.shunt({ 
          settlement: settlement,
          output:     output,
          effector:   effector
        }.compact)
      end

      def flat_record
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
