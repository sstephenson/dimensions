module Dimensions
  class Scanner
    class ScanError < ::StandardError; end

    attr_reader :pos

    def initialize(data)
      @data = data.dup
      @data.force_encoding("BINARY") if @data.respond_to?(:force_encoding)
      @size = @data.length
      @pos  = 0
      big!  # endianness
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
      data = read_data(size)
      data.unpack(format)[0]
    end

    def read_data(size)
      data = @data[@pos, size]
      advance(size)
      data
    end

    def advance(length)
      @pos += length
      raise_scan_error if @pos > @size
    end

    def skip_to(pos)
      @pos = pos
      raise_scan_error if @pos > @size
    end

    def big!
      @big = true
    end

    def little!
      @big = false
    end

    def raise_scan_error
      raise ScanError
    end
  end
end
