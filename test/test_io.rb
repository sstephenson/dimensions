require 'dimensions/test_case'

class TestIO < Dimensions::TestCase
  def test_extends_io
    with_extended_file do |file|
      assert file.is_a?(Dimensions::IO)
      assert file.respond_to?(:dimensions)
    end
  end

  def test_peeks_ahead_to_determine_dimensions
    with_extended_file do |file|
      assert_equal 0, file.pos
      assert file.width
      assert_equal 0, file.pos
    end
  end

  def test_skips_peeking_if_closed
    with_extended_file do |file|
      file.close
      assert ! file.width
    end
  end

  def test_skips_peeking_if_offset
    with_extended_file do |file|
      file.read 1
      assert ! file.width
      assert_equal 1, file.pos
    end
  end

  private
    def with_extended_file
      with_fixture("screenshot.png") do |file|
        yield Dimensions(file)
      end
    end
end
