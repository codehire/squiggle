
class ParserTest < ActiveSupport::TestCase
  # TODO: Timestamp parsing
  # TODO: Rename this to SquidParserTest

  test "basic parsing" do
    raw = "1253604221  19 127.0.0.1 TCP_MISS/200 562 GET http://www.gravatar.com/blavatar/e81cfb9068d04d1cfd598533bb380e1f?s=16&d=http://s.wordpress.com/favicon.ico - NONE/- text/html"
    parser = Squiggle::SquidStandardParser.new('Adelaide')
    logline = parser.parse(raw)
    assert logline.valid?
    assert_equal "2009-09-22 16:53:41 +0930", logline.created_at.to_s
    assert_equal "127.0.0.1", logline.client_ip
    assert_equal false, logline.cached
    assert_equal false, logline.cached? # Method alias
    assert_equal "200", logline.http_resp_code
    assert_equal 562, logline.bytes
  end

  test "cached status" do

  end

  test "page view status" do

  end

  test "blocked status" do

  end
end
