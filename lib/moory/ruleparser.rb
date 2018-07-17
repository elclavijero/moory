module Moory
  module RuleParser
    RULES = [
      { origin: 'origin',   stimulus: ':', settlement: 'stimulus'   },
      
      { origin: 'stimulus', stimulus: ':', settlement: 'settlement' },
      { origin: 'stimulus', stimulus: '/', settlement: 'output'     },
      
      { origin: 'output',   stimulus: ':', settlement: 'settlement' },
      { origin: 'output',   stimulus: '/', settlement: 'effector'   },
      
      { origin: 'effector', stimulus: ':', settlement: 'settlement' },
    ].freeze

    Transitions = Moory::Transition::Storage.new.tap { |ts|
      RULES.each { |r| ts.store(r) }
    }

    class Machine < Moory::Machine
      attr_reader :scan_data

      def initialize
        @transitions = Transitions
        prepare
      end

      def reset
        @state     = 'origin'
        @scan_data = Moory::Transition::Hasher.new
      end

      def <<(char)
        special?(char) ?
          issue(char) :
          target(state) << char
      end

      private

      def prepare
        reset
      end

      def target(state)
        @scan_data.send("#{state}=", '') unless @scan_data.send(state)
        @scan_data.send(state)
      end

      def special?(char)
        understand?(char)
      end
    end
  end
end
