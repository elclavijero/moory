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
      attr_reader :focus
      attr_reader :scan_data

      def initialize
        @transitions = Transitions
        prepare
      end

      def prepare
        @focus = 'origin'
        @scan_data = Moory::Transition::Hasher.new
      end

      alias reset prepare

      def <<;end
    end
  end
end
