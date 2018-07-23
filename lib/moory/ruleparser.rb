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

    class LineReader < Moory::Transducer
      attr_reader :scan_data

      IGNORE = [ ' ', '\t' ]

      def initialize
        @transitions = Transitions
        prepare
      end

      def reset
        @state     = 'origin'
        @scan_data = {}
      end

      def <<(string)
        puts(string)
      end

      private

      def puts(string)
        string.each_char { |c| putc(c) }
        scan_data
      end

      alias special? understand?

      def putc(char)
        (special?(char) ?
          issue(char) :
          target(state) << char) unless ignore?(char)
      end

      def prepare
        reset
      end

      def target(state)
        @scan_data.fetch(state.to_sym) { |k| @scan_data[k] = '' }
      end

      def ignore?(char)
        IGNORE.include?(char)
      end
    end

    class FileReader
      def initialize
        @line_reader = Moory::RuleParser::LineReader.new
      end

      def analyse(input)
        input
          .each_line
          .reduce([]) do |list, line|
            list << (@line_reader << (line.chomp))
            @line_reader.reset
            list
          end
      end
    end
  end
end
