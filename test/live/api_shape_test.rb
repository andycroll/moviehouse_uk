require_relative 'live_helper'

# The home page, one venue page and its what's on page: three requests.
class LiveApiShapeTest < Minitest::Test
  include ApiShapes

  COLERAINE = 'https://moviehouse.co.uk/coleraine'.freeze

  def test_pages_are_readable
    client = MoviehouseUk::Cinema.client

    assert_home_page_shape(client.send(:get, "#{client.base_url}/"))
    assert_venue_page_shape(client.send(:get, COLERAINE))
    assert_whats_on_shape(client.whats_on(COLERAINE))
  end
end
