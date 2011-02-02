
require 'uri'

module Squiggle
  class LogLine

    @@domain_parser = DomainParser.new("lib/effective_tld_names.dat")

    attr_accessor :bytes
    attr_accessor :cache_status
    attr_accessor :cache_sibling
    attr_accessor :cached
    attr_accessor :client_ip
    attr_accessor :created_at
    attr_reader   :http_resp_code
    attr_reader   :mime_type
    attr_accessor :pageview
    attr_reader   :uri
    attr_reader   :username
    attr_accessor :original_line
    attr_reader   :errors

    alias :cached? :cached
    alias :pageview? :pageview

    def initialize
      @errors = {}
      @invalid = false
      # Set defaults
      self.pageview = false
      self.cached = false
      yield self if block_given?
      class << @errors
        def to_s
          self.map { |(k,v)| "#{k} => #{v}" }.join(", ")
        end
      end
    end

    def invalid?
      # TODO: Run more checks and log if a check fails
      return true if @invalid
      if @uri.nil?
        @errors[:uri] = "Missing URL FROM #{@original_line}"
        return true
      end
      unless http_resp_code =~ /\A[+-]?\d+\Z/
        @errors[:http_resp_code] = "Invalid HTTP Response Code"
        return true
      end
      if http_resp_code && http_resp_code.to_i == 407
        @errors[:http_resp_code] = "407 code is ignored so setting to invalid"
        return true
      end
    end

    def valid?
      !invalid?
    end

    def http_resp_code=(code)
      if code == "-"
        code = "200"
      end
      @http_resp_code = code
    end

    def mime_type=(mt)
      if mt == "-"
        mt = "Unknown"
      end
      @mime_type = mt
    end

    def username=(uname)
      @username = URI.decode(uname || '').gsub(/\"/, '')
    end

    def uri=(uri)
      raise "No Domain Parser Set" unless @@domain_parser
      # CONNECT Requests
      unless uri =~ /^http/
        uri = "https://#{uri}"
      end
      @uri = @@domain_parser.parse(uri)
    rescue
      @invalid = true
      @errors[:uri] = "FAILED URL: '#{uri}' (#{$!})"
    end

    # Returns the cost for this line as a float
    # TODO: Make the logserver an event machine and use EM::Deferrable here??
    def cost
      pc = PolicyClient.new(self)
      pc.cost
    end

    def copy_line
      arr = [ bytes, cached, client_ip, created_at, uri.toplevel, uri.host, http_resp_code, mime_type, (pageview ? 1 : 0), uri.path, uri.scheme, username ]
      arr.map { |entry| "\"#{entry}\"" }.join(",")
    end

      # TODO: URI Escape? quotes around commas?
  end
end
