require 'dimensions/scanner'

module Dimensions
  class ExifScanner < Scanner
    ORIENTATIONS = [
      :top_left,
      :top_right,
      :bottom_right,
      :bottom_left,
      :left_top,
      :right_top,
      :right_bottom,
      :left_bottom
    ]

    attr_reader :orientation

    def initialize(data)
      @orientation = nil
      super
    end

    def scan
      scan_header

      offset = read_long + 6
      skip_to(offset)

      # Note: This only checks the first IFD for orientation entries,
      # which seems to work fine in my (limited) testing but might not
      # play out in practice.
      entry_count = read_short
      entry_count.times do |i|
        skip_to(offset + 2 + (12 * i))
        tag = read_short

        if tag == 0x0112 # orientation
          advance(6)
          @orientation = ORIENTATIONS[read_short - 1]
        end
      end

      @orientation
    end

    def scan_header
      advance(6)
      scan_endianness
      scan_tag_mark
    end

    def scan_endianness
      tag = [read_char, read_char]
      @big = tag == [0x4D, 0x4D]
    end

    def scan_tag_mark
      raise ScanError unless read_short == 0x002A
    end
  end
end
