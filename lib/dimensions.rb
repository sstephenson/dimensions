require 'dimensions/exif_scanner'
require 'dimensions/jpeg_scanner'
require 'dimensions/reader'

module Dimensions
  class << self
    def dimensions(io)
      reader = reader_for(io)
      [reader.width, reader.height]
    end

    def angle(io)
      reader_for(io).angle
    end

    private
      def reader_for(io)
        Reader.new.tap do |reader|
          while data = io.read(4096)
            reader << data
          end
        end
      end
  end
end
