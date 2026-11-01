require_relative '../../test_helper'

class MoviehouseUk::VersionTest < Minitest::Test
  def test_version_is_defined
    refute_nil MoviehouseUk::VERSION
  end
end
