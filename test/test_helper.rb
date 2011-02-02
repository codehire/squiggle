require 'active_support'
require 'stringio'
require 'test/unit'
require 'factory_girl'
require 'faker'
require File.dirname(__FILE__) + '/../lib/squiggle'

Factory.define(:logline, :class => Squiggle::LogLine) do |f|
  f.bytes { rand(1000) }
  f.cache_status { '' }
  f.cache_sibling { '' }
  f.created_at { Time.now }
  f.client_ip { (1..4).to_a.map { rand(254) + 1 }.join(".") }
  f.uri { "http://#{Faker::Internet.domain_name}" }
  f.username { Faker::Internet.user_name }
  f.mime_type { "text/html" }
  f.http_resp_code "200"
end

class ActiveSupport::TestCase
  def assert_extracted_domain(result, source)
    @parser ||= Squiggle::DomainParser.new("lib/effective_tld_names.dat") 
    assert_equal result, @parser.parse(source).toplevel
  end

  def suffix(key, values)
    if values.empty? or values == '*'
      yield(key.gsub(/\!/, ''))
    else
      values.each do |k,v|
        unless k == "*"
          suffix("#{k}.#{key}", v) { |e| yield e.gsub(/\!/, '') }
        end
      end
    end
  end

  protected
    def read_dat_file(file_name)
      @public_suffixes = {}
      File.readlines(file_name).each do |line|
        line = line.strip
        unless (line =~ /\/\//) || line.empty?
          parts = line.split(".").reverse

          sub_hash = @public_suffixes
          parts.each do |part|
            sub_hash = (sub_hash[part] ||= {})
          end
        end
      end
      @public_suffixes
    end
end
