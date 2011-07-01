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
      @reader.width
    end

    def height
      @reader.height
    end

    def angle
      @reader.angle
    end
  end
end
