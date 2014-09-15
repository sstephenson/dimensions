require 'dimensions'

module Dimensions
  FIXTURE_ROOT = File.expand_path('../../fixtures', __FILE__)

  begin
    require 'minitest/autorun'
    begin
      # 2.0.0
      class TestCase < MiniTest::Test; end
    rescue NameError
      # 1.9.3
      class TestCase < MiniTest::Unit::TestCase; end
    end
  rescue LoadError
    # 1.8.7
    require 'test/unit'
    class TestCase < Test::Unit::TestCase; end
  end

  class TestCase
    undef_method(:default_test) if method_defined?(:default_test)

    def with_fixture(filename, &block)
      File.open(fixture_path(filename), "rb", &block)
    end

    def fixture_path(filename)
      File.join(FIXTURE_ROOT, filename)
    end
  end
end
