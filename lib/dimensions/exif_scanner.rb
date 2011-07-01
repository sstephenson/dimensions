module Dimensions
  class ExifScanner
    class ScanError < ::StandardError; end

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
      @data = data.dup
      @data.force_encoding("BINARY") if @data.respond_to?(:force_encoding)
      @size = data.length
      @pos = 0
      @orientation = nil
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

    def read_char
      read(1, "C")
    end

    def read_short
      read(2, @big ? "n" : "v")
    end

    def read_long
      read(4, @big ? "N" : "V")
    end

    def read(size, format)
      if data = @data[@pos, size]
        @pos += size
        data.unpack(format)[0]
      else
        raise ScanError
      end
    end

    def advance(length)
      @pos += length
      raise ScanError if @pos > @size
    end

    def skip_to(pos)
      @pos = pos
      raise ScanError if @pos > @size
    end
  end
end
