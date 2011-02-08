module Squiggle
  class ChunkParser
    def initialize(chunk, options = {})
      options[:parser] = SquidStandardParser
      @parser = options[:parser].new(options[:time_zone])
      @lines = chunk.split("\n").select { |e| e.length > 5 }
      @current_line = next_line
      Rails.logger.info("Chunk Parser received: #{@lines.size} lines")
    end

    def has_lines?
      !@lines.empty?
    end

    def current_line
      @current_line
    end

    def next_line
      return nil if @lines.empty?
      to_parse = @lines.shift
      logline = @parser.parse(to_parse)
      if logline.invalid?
        #STDERR.puts "Line is INVALID"
        logline = self.next_line # recurse
      end
      @current_line = logline
    end
  end
end
