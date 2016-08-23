require "test/unit"
require "pathname"

module TestHelper
  module_function

  def root
    Pathname(__dir__).join("../../")
  end

  def fixture_root
    root.join("test/fixtures")
  end
end

World Test::Unit::Assertions
