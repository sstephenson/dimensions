Dimensions
==========

Dimensions is a pure Ruby library for reading the width, height and
rotation angle of GIF, PNG, JPEG and TIFF images.

Use the `dimensions`, `width` and `height` methods on the `Dimensions`
module to measure image files:

```ruby
require 'dimensions'

Dimensions.dimensions("upload_bird.jpg")  # => [300, 225]
Dimensions.width("upload_bird.jpg")       # => 300
Dimensions.height("upload_bird.jpg")      # => 225
```

Many cameras and smartphones set the EXIF orientation attribute for
photos taken in portrait or landscape mode. The Dimensions library
reads this attribute and swaps the `width` and `height` values
automatically to accurately reflect how the image looks when
rotated. You can use the `angle` method to check a JPEG image's
orientation in degrees:

```ruby
Dimensions.angle("upload_bird.jpg")       # => 0
Dimensions.angle("rotated.jpg")           # => 90
```

### Reading dimensions from a stream

Pass an IO object to the `Dimensions` method to extend it with the
`Dimensions::IO` module and transparently detect its dimensions and
orientation as it is read. Once the IO has been sufficiently read, its
`width`, `height` and `angle` methods will return non-nil values
(assuming its contents are an image).

```ruby
require 'dimensions'
require 'json'
require 'securerandom'

module Uploader
  def self.call(env)
    body = Dimensions(env["rack.input"])

    # Handle the upload
    token = SecureRandom.hex(20)
    path  = File.join(UPLOAD_PATH, token)
    File.open(path, "wb") { |file| file.write body.read }

    # Return the width and height as JSON
    [
      200,
      {"Content-Type" => "application/json"},
      [JSON.dump(
        "token"  => token,
        "width"  => body.width,
        "height" => body.height
      )]
    ]
  end
end
```

### Version History

**1.3.0** (November 26, 2013)

* Added support for calling `#dimensions` on a Dimensions-extended
  rewindable IO without first calling `#read`.

**1.2.0** (April 25, 2012)

* Added support for measuring the dimensions of TIFF images.

**1.1.0** (April 1, 2012)

* Fixed an issue where images with certain invalid orientation values
  would be improperly treated as having an angle of 270 degrees.
* Eliminated a message when loading Dimensions with warnings enabled.

**1.0.0** (July 1, 2011)

* Initial release.

### License

(The MIT License)

Copyright &copy; 2012 Sam Stephenson

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
