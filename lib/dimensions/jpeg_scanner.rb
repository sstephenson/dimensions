require "dimensions/exif_scanner"

module Dimensions
  class JpegScanner
    class ScanError < ::StandardError; end

    SOF_MARKERS = [0xC0..0xC3, 0xC5..0xC7, 0xC9..0xCB, 0xCD..0xCF]
    EOI_MARKER  = 0xD9  # end of image
    SOS_MARKER  = 0xDA  # start of stream
    COM_MARKER  = 0xFE  # comment
    APP1_MARKER = 0xE1  # maybe EXIF

    attr_reader :width, :height, :angle

    def initialize(data)
      @data   = data.dup
      @data.force_encoding("BINARY") if @data.respond_to?(:force_encoding)
      @size   = @data.length
      @pos    = 0
      @angle  = 0
      @width  = nil
      @height = nil
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

      @width && @height
    end

    def read_next_marker
      c = read_char while c != 0xFF
      c = read_char while c == 0xFF
      c
    end

    def scan_start_of_frame
      length = read_int
      depth  = read_char
      height = read_int
      width  = read_int
      size   = read_char

      if length == (size * 3) + 8
        @width, @height = width, height
      else
        raise ScanError
      end
    end

    def scan_app1_frame
      frame = read_frame
      if frame[0..5] == "Exif\000\000"
        scanner = ExifScanner.new(frame)
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
      length = read_int - 2
      frame = @data[@pos, length]
      @pos += length
      raise ScanError if @pos > @size
      frame
    end

    def skip_frame
      length = read_int - 2
      advance(length)
    end

    def read_int
      (read_char << 8) + read_char
    end

    def read_char
      if char = @data[@pos, 1]
        @pos += 1
        char.unpack("C")[0]
      else
        raise ScanError
      end
    end

    def advance(length)
      @pos += length
      raise ScanError if @pos > @size
    end
  end
end
