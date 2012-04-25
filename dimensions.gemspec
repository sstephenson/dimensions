unless defined? Dimensions::VERSION
  $:.unshift File.expand_path("../lib", __FILE__)
  require "dimensions/version"
end

spec = Gem::Specification.new do |s|
  s.name         = "dimensions"
  s.version      = Dimensions::VERSION
  s.platform     = Gem::Platform::RUBY
  s.authors      = ["Sam Stephenson"]
  s.email        = ["sstephenson@gmail.com"]
  s.homepage     = "https://github.com/sstephenson/dimensions"
  s.summary      = "Pure Ruby dimension measurement for GIF, PNG, JPEG and TIFF images"
  s.description  = "A pure Ruby library for measuring the dimensions and rotation angles of GIF, PNG, JPEG and TIFF images."
  s.files        = Dir["README.md", "LICENSE", "lib/**/*.rb"]
  s.require_path = "lib"
end
