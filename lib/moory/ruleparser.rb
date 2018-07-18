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

    class LineReader < Moory::Machine
      attr_reader :scan_data

      IGNORE = [ ' ', '\t' ]

      def initialize
        @transitions = Transitions
        prepare
      end

      def reset
        @state     = 'origin'
        @scan_data = Moory::Transition::Hasher.new
      end

      def puts(string)
        string.each_char { |c| putc(c) }
        scan_data
      end

      alias << puts

      def putc(char)
        (special?(char) ?
          issue(char) :
          target(state) << char) unless ignore?(char)
      end

      alias special? understand?

      private

      def prepare
        reset
      end

      def target(state)
        @scan_data.send("#{state}=", '') unless @scan_data.send(state)
        @scan_data.send(state)
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
        result = []
        input.each_line do |line|
          hasher = @line_reader << (line.chomp)
          result << hasher
          @line_reader.reset
        end
        result
      end
    end
  end
end
