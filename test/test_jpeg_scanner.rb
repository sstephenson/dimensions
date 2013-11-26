require File.expand_path('../dimensions/test_case', __FILE__)

class TestJpegScanner < Dimensions::TestCase
  def test_scanning_jpeg
    with_fixture("upload_bird.jpg") do |file|
      scanner = Dimensions::JpegScanner.new(file.read)
      assert scanner.scan
      assert_equal 300, scanner.width
      assert_equal 225, scanner.height
      assert_equal 0, scanner.angle
    end
  end

  def test_scanning_rotated_jpeg
    with_fixture("rotated.jpg") do |file|
      scanner = Dimensions::JpegScanner.new(file.read)
      assert scanner.scan
      assert_equal 2592, scanner.width
      assert_equal 1936, scanner.height
      assert_equal 90, scanner.angle
    end
  end
end
