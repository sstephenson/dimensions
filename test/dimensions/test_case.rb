require 'dimensions'
require 'test/unit'

module Dimensions
  FIXTURE_ROOT = File.expand_path('../../fixtures', __FILE__)

  class TestCase < Test::Unit::TestCase
    undef_method(:default_test) if method_defined?(:default_test)

    def with_fixture(filename, &block)
      File.open(fixture_path(filename), "rb", &block)
    end

    def fixture_path(filename)
      File.join(FIXTURE_ROOT, filename)
    end
  end
end
