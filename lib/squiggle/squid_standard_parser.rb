module Squiggle
  # Based on standard squid log format
  # %ts.%03tu %6tr %>a %Ss/%03Hs %<st %rm %ru %un %Sh/%<A %mt
  # Example:
  # 1253604221.678  19 127.0.0.1 TCP_REFRESH_FAIL_HIT/302 562 GET http://www.gravatar.com/blavatar/e81cfb9068d04d1cfd598533bb380e1f?s=16&d=http://s.wordpress.com/favicon.ico - NONE/- text/html
  #
  # TODO: Write a log format parser like squid's
  class SquidStandardParser < Base
    def process(line)
      if line.nil?
        return LogLine.new
      end
      line.strip!
      if line.empty?
        return LogLine.new
      end
      toks = line.split(/\s+/)
      return LogLine.new do |ll|
        ll.original_line = line
        ll.created_at = parse_timestamp(toks[0])
        ll.client_ip = toks[2]
        ll.cache_status, ll.http_resp_code = (toks[3] || "").split("/")
        ll.bytes = toks[4].to_i
        ll.uri = toks[6]
        ll.username = toks[7]
        tok8 = toks[8].nil? ? nil : toks[8].split("/")
        ll.cache_sibling = tok8.nil? ? nil : tok8[0]
        ll.mime_type = toks[9]
      end
    end

    def cached?(logline)
      # TODO Implement this
      false
    end
  end
end
