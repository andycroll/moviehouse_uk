require_relative '../../../test_helper'

class FixtureShapeTest < Minitest::Test
  include ApiShapes
  include FixturesHelper

  def test_home_page_fixture_matches_shape
    assert_home_page_shape(home_html)
  end

  def test_venue_page_fixtures_match_shape
    WebsiteStubs::VENUES.each { |venue| assert_venue_page_shape(venue_html(venue)) }
  end

  def test_whats_on_fixture_matches_shape
    assert_whats_on_shape(whats_on_html('MH_COLE'))
  end
end
