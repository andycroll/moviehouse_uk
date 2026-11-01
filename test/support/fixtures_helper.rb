# Read fixtures from disk: pages captured from moviehouse.co.uk, with the
# what's on page trimmed to a few films on a few dates and venue pages to
# their head. They follow the shape in api_shapes.rb.
module FixturesHelper
  private

  def home_html
    read_fixture('website/home.html')
  end

  def venue_html(venue)
    read_fixture("website/venue-#{venue}.html")
  end

  def whats_on_html(cinema_id)
    read_fixture("website/whatson-#{cinema_id}.html")
  end

  def read_fixture(filepath)
    File.binread(File.expand_path("../../fixtures/#{filepath}", __FILE__))
  end
end
