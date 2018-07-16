module Moory
  module Transition
    class Storage
      def storage
        @storage ||= {}
      end
  
      def count
        storage.size
      end
  
      def store(params)
        storage.merge!(transition(params))
      end
  
      private
  
      def transition(params)
        poise(params).shunt(response(params))
      end
  
      def poise(params)
        Moory::Pair.new(
          left:  params['source'],
          right: params['stimulus']
        )
      end
  
      def response(params)
        { 
          state:    params['target'],
          output:   params['output'],
          effector: params['effector']
        }.compact
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

      def poise
        Moory::Pair.new(
          left:  origin,
          right: stimulus
        )
      end

      def response
        { 
          settlement: settlement,
          output:     output,
          effector:   effector
        }.compact
      end
    end
  end
end
