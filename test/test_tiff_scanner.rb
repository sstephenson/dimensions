require 'dimensions/test_case'

class TestTiffScanner < Dimensions::TestCase
  def test_scanning_tiff_with_short_values
    with_fixture("short.tif") do |file|
      scanner = Dimensions::TiffScanner.new(file.read)
      assert scanner.scan
      assert_equal 50, scanner.width
      assert_equal 20, scanner.height
    end
  end

  def test_scanning_tiff_with_long_values
    with_fixture("long.tif") do |file|
      scanner = Dimensions::TiffScanner.new(file.read)
      assert scanner.scan
      assert_equal 67_000, scanner.width
      assert_equal 1, scanner.height
    end
  end
end
