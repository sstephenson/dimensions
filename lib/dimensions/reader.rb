require 'dimensions/jpeg_scanner'

module Dimensions
  class Reader
    GIF_HEADER    = [0x47, 0x49, 0x46, 0x38]
    PNG_HEADER    = [0x89, 0x50, 0x4E, 0x47]
    JPEG_HEADER   = [0xFF, 0xD8, 0xFF]
    TIFF_HEADER_I = [0x49, 0x49, 0x2A, 0x00]
    TIFF_HEADER_M = [0x4D, 0x4D, 0x00, 0x2A]
    BMP_HEADER    = [0x42, 0x4D]

    attr_reader :type, :width, :height, :angle

    def initialize
      @process = :determine_type
      @type    = nil
      @width   = nil
      @height  = nil
      @angle   = nil
      @size    = 0
      @data    = ""
      @data.force_encoding("BINARY") if @data.respond_to?(:force_encoding)
    end

    def <<(data)
      if @process
        @data << data
        @size = @data.length
        process
      end
    end

    def process(process = @process)
      send(@process) if @process = process
    end

    def determine_type
      if @size >= 4
        bytes = @data.unpack("C4")

        if match_header(GIF_HEADER, bytes)
          @type = :gif
        elsif match_header(PNG_HEADER, bytes)
          @type = :png
        elsif match_header(JPEG_HEADER, bytes)
          @type = :jpeg
        elsif match_header(TIFF_HEADER_I, bytes) || match_header(TIFF_HEADER_M, bytes)
          @type = :tiff
        elsif match_header(BMP_HEADER, bytes)
          @type = :bmp
        end

        process @type ? :"extract_#{type}_dimensions" : nil
      end
    end

    def extract_bmp_dimensions
      if @size >= 26
        dib_header_size = @data.unpack("x14C").first
        @width, @height = if dib_header_size == 12
                            @data.unpack("x18v2")
                          else
                            @data.unpack("x18V2")
                          end
        process nil
      end
    end

    def extract_gif_dimensions
      if @size >= 10
        @width, @height = @data.unpack("x6v2")
        process nil
      end
    end

    def extract_png_dimensions
      if @size >= 24
        @width, @height = @data.unpack("x16N2")
        process nil
      end
    end

    def extract_jpeg_dimensions
      scanner = JpegScanner.new(@data)
      if scanner.scan
        @width  = scanner.width
        @height = scanner.height
        @angle  = scanner.angle

        if @angle == 90 || @angle == 270
          @width, @height = @height, @width
        end

        process nil
      end
    rescue JpegScanner::ScanError
    end

    def extract_tiff_dimensions
      scanner = TiffScanner.new(@data)
      if scanner.scan
        @width  = scanner.width
        @height = scanner.height
        process nil
      end
    rescue TiffScanner::ScanError
    end

    def match_header(header, bytes)
      bytes[0, header.length] == header
    end
  end
end
