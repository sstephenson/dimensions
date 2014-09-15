require 'dimensions/test_case'

class TestExifScanner < Dimensions::TestCase
  def test_scanning_exif_with_top_left_orientation
    with_fixture("top_left.exif") do |file|
      scanner = Dimensions::ExifScanner.new(file.read)
      assert scanner.scan
      assert_equal :top_left, scanner.orientation
    end
  end

  def test_scanning_exif_with_right_top_orientation
    with_fixture("right_top.exif") do |file|
      scanner = Dimensions::ExifScanner.new(file.read)
      assert scanner.scan
      assert_equal :right_top, scanner.orientation
    end
  end

  def test_scanning_exif_with_invalid_orientation
    with_fixture("invalid.exif") do |file|
      scanner = Dimensions::ExifScanner.new(file.read)
      assert_nil scanner.scan
      assert_nil scanner.orientation
    end
  end
end
