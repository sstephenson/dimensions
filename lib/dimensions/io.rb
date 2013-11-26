require 'dimensions/reader'

module Dimensions
  module IO
    def self.extended(io)
      io.instance_variable_set(:@reader, Reader.new)
    end

    def read(*args)
      super.tap do |data|
        @reader << data if data
      end
    end

    def dimensions
      [width, height] if width && height
    end

    def width
      peek
      @reader.width
    end

    def height
      peek
      @reader.height
    end

    def angle
      peek
      @reader.angle
    end

    private
      def peek
        unless no_peeking?
          read(pos + 1024) while @reader.width.nil? && pos < 6144
          rewind
        end
      end

      def no_peeking?
        @reader.width || closed? || pos != 0
      end
  end
end
