module Moory
  module Transition
    class Storage
      def count
        storage.size
      end
      
      def store(params)
        storage.merge!(Record.new(params)) do |key, oldval, newval|
          oldval.merge!(newval)
        end
      end

      def the(origin:, stimulus:)
        storage.dig(origin, stimulus)
      end

      def receptors(origin:)
        storage
          .select { |k| k == origin }
          .values
      end

      private

      def storage
        @storage ||= {}
      end
    end

    Record = Struct.new(
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

      def to_hash
        return {} unless valid?

        p = Pair.new(left: origin, right: stimulus)

        p.shunt({ 
          settlement: settlement,
          output:     output,
          effector:   effector
        }.compact)
      end
    end
  end
end
