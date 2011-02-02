
class LogLineTest < ActiveSupport::TestCase
  test "basic log line" do
    logline = Factory.build(:logline)
    assert logline.valid?
    assert logline.errors.empty?
  end

  test "non-integer http response code" do
    logline = Factory.build(:logline, :http_resp_code => "gooby")
    assert !logline.valid?
    assert !logline.errors.empty?
    assert logline.errors.has_key?(:http_resp_code)
  end

  test "407 http response code is invalid" do
    logline = Factory.build(:logline, :http_resp_code => "407")
    assert !logline.valid?
    assert !logline.errors.empty?
    assert logline.errors.has_key?(:http_resp_code)
  end

  test "URL is valid" do
    logline = Factory.build(:logline, :uri => "http://www.google.com.au/search?q=bar")
    assert logline.uri
    assert_equal "www.google.com.au", logline.uri.host
    assert_equal "/search", logline.uri.path
    assert_equal "http", logline.uri.scheme
    assert_equal "google.com.au", logline.uri.toplevel
  end

  test "CONNECT request is valid" do
    logline = Factory.build(:logline, :uri => "www.westpac.com.au:443")
    assert logline.uri
    assert_equal "www.westpac.com.au", logline.uri.host
    assert_equal "", logline.uri.path
    assert_equal "https", logline.uri.scheme
    assert_equal "westpac.com.au", logline.uri.toplevel
  end

  test "ssl URI is valid" do
    logline = Factory.build(:logline, :uri => "https://edsuite.decs.sa.edu.au/login.php")
    assert logline.uri
    assert_equal "edsuite.decs.sa.edu.au", logline.uri.host
    assert_equal "/login.php", logline.uri.path
    assert_equal "https", logline.uri.scheme
    assert_equal "decs.sa.edu.au", logline.uri.toplevel
  end

  test "blank username is valid" do
    logline = Factory.build(:logline, :username => '-')
    assert logline.valid?
    assert_equal logline.username, "-"
  end

  test "digest parsed username is valid" do
    logline = Factory.build(:logline, :username => '%22daniel%20draper%22')
    assert logline.valid?
    assert_equal logline.username, "daniel draper"
  end

  test "copy line" do
    logline = Factory.build(:logline)
    assert logline.copy_line
  end
end
