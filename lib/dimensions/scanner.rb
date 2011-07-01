module Dimensions
  class Scanner
    class ScanError < ::StandardError; end

    def initialize(data)
      @data = data.dup
      @data.force_encoding("BINARY") if @data.respond_to?(:force_encoding)
      @size = @data.length
      @pos  = 0
      @big  = true  # endianness
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

    def read_data(size)
      data = @data[@pos, size]
      advance(size)
      data
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
