require File.expand_path('../dimensions/test_case', __FILE__)

class TestReader < Dimensions::TestCase
  def test_identifying_gif_file
    assert_type :gif, "ad.gif"
    assert_type :gif, "basecamp.gif"
  end

  def test_identifying_png_file
    assert_type :png, "close.png"
    assert_type :png, "screenshot.png"
  end

  def test_identifying_jpeg_file
    assert_type :jpeg, "upload_bird.jpg"
    assert_type :jpeg, "rotated.jpg"
  end

  def assert_type(type, filename)
    assert_equal type, reader_for(filename).type
  end

  def reader_for(filename)
    with_fixture(filename) do |file|
      Dimensions::Reader.new.tap do |reader|
        while data = file.read(4096)
          reader << data
        end
      end
    end
  end
end
