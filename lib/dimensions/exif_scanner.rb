require 'dimensions/scanner'
require 'dimensions/tiff_scanning'

module Dimensions
  class ExifScanner < Scanner
    include TiffScanning

    ORIENTATION_TAG = 0x0112
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

      scan_ifd do |tag|
        if tag == ORIENTATION_TAG
          value = read_integer_value
          if valid_orientation?(value)
            @orientation = ORIENTATIONS[value - 1]
          end
        end
      end

      @orientation
    end

    def valid_orientation?(value)
      (1..ORIENTATIONS.length).include?(value)
    end
  end
end
