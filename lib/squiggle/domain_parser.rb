require 'domainatrix'

class Domainatrix::Url
  attr_accessor :query

  def toplevel
    [ domain, public_suffix ].compact.join(".")
  end
end

module Squiggle
  class DomainParser < Domainatrix::DomainParser

    def parse(url)
      uri = URI.parse(url)
      Domainatrix::Url.new(parse_domains_from_host(uri.host).merge({
        :scheme => uri.scheme,
        :host   => uri.host,
        :path   => uri.path,
        :query  => uri.query,
        :url    => url
      }))
    end

    # TODO: This is a big monkey patch - we should be forking and fixing this
    def parse_domains_from_host(host)
      parts = host.split(".").reverse
      public_suffix = []
      domain = ""
      subdomains = []
      sub_hash = @public_suffixes
      parts.each_index do |i|
        part = parts[i]
        sub_parts = sub_hash[part]
        sub_hash = sub_parts
        if sub_parts.empty? || !sub_parts.has_key?(parts[i+1])
          public_suffix << part
          domain = parts[i+1]
          subdomains = parts.slice(i+2, parts.size)
          break
        else
          public_suffix << part
        end
      end
      {:public_suffix => public_suffix.reverse.join("."), :domain => domain, :subdomain => subdomains.reverse.join(".")}
    rescue
      # Applies to IP Addresses here too
      {:public_suffix => nil, :domain => host, :subdomain => nil}
    end
  end
end
