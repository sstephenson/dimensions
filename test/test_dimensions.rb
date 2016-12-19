require 'dimensions/test_case'

class TestDimensions < Dimensions::TestCase
  def test_animated_gif_dimensions
    assert_dimensions "ad.gif", 300, 250
  end

  def test_static_gif_dimensions
    assert_dimensions "basecamp.gif", 153, 36
  end

  def test_small_png_dimensions
    assert_dimensions "close.png", 25, 25
  end

  def test_large_png_dimensions
    assert_dimensions "screenshot.png", 769, 523
  end

  def test_jpeg_dimensions
    assert_dimensions "upload_bird.jpg", 300, 225
  end

  def test_rotated_jpeg_dimensions
    assert_dimensions "rotated.jpg", 1936, 2592
    assert_angle "rotated.jpg", 90
  end

  def test_tiff_dimensions
    assert_dimensions "short.tif", 50, 20
  end

  def test_psd_dimensions
    assert_dimensions "f-and-f.psd", 193, 147
  end

  def assert_dimensions(filename, expected_width, expected_height)
    actual_width, actual_height = Dimensions.dimensions(fixture_path(filename))
    assert_equal "#{expected_width}x#{expected_height}", "#{actual_width}x#{actual_height}"
  end

  def assert_angle(filename, expected_angle)
    actual_angle = Dimensions.angle(fixture_path(filename))
    assert_equal expected_angle, actual_angle
  end
end
