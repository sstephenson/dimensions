require 'dimensions/exif_scanner'
require 'dimensions/io'
require 'dimensions/jpeg_scanner'
require 'dimensions/reader'
require 'dimensions/scanner'
require 'dimensions/tiff_scanner'
require 'dimensions/tiff_scanning'
require 'dimensions/version'

# Extends an IO object with the `Dimensions::IO` module, which adds
# `dimensions`, `width`, `height` and `angle` methods. The methods
# will return non-nil values once the IO has been sufficiently read,
# assuming its contents are an image.
def Dimensions(io)
  io.extend(Dimensions::IO)
end

module Dimensions
  class << self
    # Returns an array of [width, height] representing the dimensions
    # of the image at the given path.
    def dimensions(path)
      io_for(path).dimensions
    end

    # Returns the width of the image at the given path.
    def width(path)
      io_for(path).width
    end

    # Returns the height of the image at the given path.
    def height(path)
      io_for(path).height
    end

    # Returns the rotation angle of the JPEG image at the given
    # path. If the JPEG is rotated 90 or 270 degrees (as is often the
    # case with photos from smartphones, for example) its width and
    # height will be swapped to accurately reflect the rotation.
    def angle(path)
      io_for(path).angle
    end

    private
      def io_for(path)
        Dimensions(File.open(path, "rb")).tap do |io|
          io.read
          io.close
        end
      end
  end
end
