require 'active_support'

class DomainParserTest < ActiveSupport::TestCase
  test "ip address form" do
    assert_extracted_domain "192.168.10.100", "http://192.168.10.100/foo/bar"
  end

  test "internal server with no FQDN" do
    assert_extracted_domain "internal", "http://internal/foo/bar"
  end

  test "internal server with FQDN" do
    assert_extracted_domain "internal.highschool", "http://internal.highschool/foo/bar"
  end

  test "valid domains" do
    suffixes = read_dat_file("lib/effective_tld_names.dat")
    suffixes.each do |(k,v)|
      suffix(k,v) do |entry|
        assert_extracted_domain("website.#{entry}", "http://website.#{entry}/foo/bar?q=abc123")
        assert_extracted_domain("website.#{entry}", "http://www.website.#{entry}/foo/bar?q=abc123")
        assert_extracted_domain("website.#{entry}", "http://subdomain.website.#{entry}/foo/bar?q=abc123")
      end
    end
  end
end
