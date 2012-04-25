require 'dimensions/scanner'
require 'dimensions/tiff_scanning'

module Dimensions
  class TiffScanner < Scanner
    include TiffScanning

    WIDTH_TAG  = 0x100
    HEIGHT_TAG = 0x101

    attr_reader :width, :height

    def initialize(data)
      @width  = nil
      @height = nil
      super
    end

    def scan
      scan_header

      scan_ifd do |tag|
        if tag == WIDTH_TAG
          @width = read_integer_value
        elsif tag == HEIGHT_TAG
          @height = read_integer_value
        end
      end

      @width && @height
    end
  end
end
