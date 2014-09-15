module Dimensions
  module TiffScanning
    def scan_header
      scan_endianness
      scan_tag_mark
      scan_and_skip_to_offset
    end

    def scan_endianness
      tag = [read_char, read_char]
      tag == [0x4D, 0x4D] ? big! : little!
    end

    def scan_tag_mark
      raise_scan_error unless read_short == 0x002A
    end

    def scan_and_skip_to_offset
      offset = read_long
      skip_to(offset)
    end

    def scan_ifd
      offset = pos
      entry_count = read_short

      entry_count.times do |i|
        skip_to(offset + 2 + (12 * i))
        tag = read_short
        yield tag
      end
    end

    def read_integer_value
      type = read_short
      advance(4)

      if type == 3
        read_short
      elsif type == 4
        read_long
      else
        raise_scan_error
      end
    end
  end
end
