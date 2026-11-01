# The parts of Movie House pages the gem reads. Checked against the trimmed
# fixtures and, in the live suite, against real pages held only in memory.
module ApiShapes
  VENUE_URL = %r{\Ahttps://moviehouse\.co\.uk/[a-z-]+\z}
  SITE_CODE = /\AMH_[A-Z]{4}\z/
  SHOWTIME_HREF = %r{\A/booking/\d+/[\w-]+\z}
  BOOKING_URL = %r{\Ahttps://moviehouse[a-z]+\.admit-one\.co\.uk/tickets/\?perfCode=\d+\z}
  SHOWTIME = %r{<a class="[^"]*perfButton[^"]*" href="([^"]*)"[^>]*>(.*?)</a>}m
  TAB_TIMESTAMP = /<button data-target="\d+" value="\d{10}"/

  private

  def assert_home_page_shape(html)
    venues = html.scan(Cinebase::A1web::Client::VENUE).map(&:first).uniq
    refute_empty venues
    venues.each { |url| assert_match VENUE_URL, url }
    assert_empty html.scan(Cinebase::A1web::Client::SITE_CODES)
  end

  def assert_venue_page_shape(html)
    assert_match SITE_CODE, html[Cinebase::A1web::Client::SITE_CODE, 1]
  end

  def assert_whats_on_shape(html)
    panels = html.scan(Cinebase::A1web::Listings::PANEL).flatten
    refute_empty panels
    panels.each { |key| assert_match(/\A\d{1,2}\z/, key) }
    assert_match TAB_TIMESTAMP, html
    assert_match Cinebase::A1web::Listings::FILM, html
    showtimes = html.scan(SHOWTIME)
    refute_empty showtimes
    showtimes.each do |href, button|
      assert_match SHOWTIME_HREF, href
      assert_match(/\A\s*\d{2}:\d{2}\s*\z/, button)
    end
  end
end
