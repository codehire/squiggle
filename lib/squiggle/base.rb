
module Squiggle
  class Base
    def initialize(time_zone)
      @time_zone = time_zone
    end

    def parse(line)
      logline = process(line)
      if logline.valid?
        logline.cached = cached?(logline)
        logline.pageview = pageview?(logline)
      else
        STDERR.puts("INVALID LINE (#{logline.errors}): '#{line}'") unless line.blank?
      end
      logline
    end
    
    def pageview?(logline)
      case logline.mime_type
        when /html/,/text/,/pdf/ then true
        else false
      end
    end

    def cached?(logline)
      # TODO Implement this
      false
    end

    # Return the time in the client's time zone
    def parse_timestamp(str)
      # Parses the timestamp into localtime
      t = Time.at(str.gsub(/^L/, '').to_i)
      # TODO: Right now this will only work with the NFAgent - can't be used on the server as we can't translate to an arbitrary TZ
      # Return the time zone in the clients TZ
      # t.in_time_zone(@time_zone)
    end
  end
end
