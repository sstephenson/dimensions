require 'dimensions/exif_scanner'

module Dimensions
  class JpegScanner < Scanner
    SOF_MARKERS = [0xC0..0xC3, 0xC5..0xC7, 0xC9..0xCB, 0xCD..0xCF]
    EOI_MARKER  = 0xD9  # end of image
    SOS_MARKER  = 0xDA  # start of stream
    APP1_MARKER = 0xE1  # maybe EXIF

    attr_reader :width, :height, :angle

    def initialize(data)
      @width  = nil
      @height = nil
      @angle  = 0
      super
    end

    def scan
      advance(2)

      while marker = read_next_marker
        case marker
        when *SOF_MARKERS
          scan_start_of_frame
        when EOI_MARKER, SOS_MARKER
          break
        when APP1_MARKER
          scan_app1_frame
        else
          skip_frame
        end
      end

      width && height
    end

    def read_next_marker
      c = read_char while c != 0xFF
      c = read_char while c == 0xFF
      c
    end

    def scan_start_of_frame
      length = read_short
      read_char # depth, unused
      height = read_short
      width  = read_short
      size   = read_char

      if length == (size * 3) + 8
        @width, @height = width, height
      else
        raise_scan_error
      end
    end

    def scan_app1_frame
      frame = read_frame
      if frame[0..5] == "Exif\000\000"
        scanner = ExifScanner.new(frame[6..-1])
        if scanner.scan
          case scanner.orientation
          when :bottom_right
            @angle = 180
          when :left_top, :right_top
            @angle = 90
          when :right_bottom, :left_bottom
            @angle = 270
          end
        end
      end
    rescue ExifScanner::ScanError
    end

    def read_frame
      length = read_short - 2
      read_data(length)
    end

    def skip_frame
      length = read_short - 2
      advance(length)
    end
  end
end
