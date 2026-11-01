require_relative '../../test_helper'

class MoviehouseUk::PerformanceTest < Minitest::Test
  include WebsiteStubs

  DATE = Date.new(2026, 11, 1)
  TICKETS = 'https://moviehousecoleraine.admit-one.co.uk/tickets/?perfCode='.freeze

  def setup
    stub_website
    MoviehouseUk::Cinema.instance_variable_set(:@venues_hash, nil)
  end

  def test_at_returns_performances_in_time_order
    performances = performances_at('MH_COLE')

    assert(performances.all? { |p| p.instance_of?(MoviehouseUk::Performance) })
    assert_equal 14, performances.count
    assert_equal performances.map(&:starting_at).sort, performances.map(&:starting_at)
  end

  def test_at_reads_every_date_from_one_page
    performances_at('mh_cole')

    assert_requested :get, "#{COLERAINE}/whatson", times: 1
  end

  def test_at_keeps_to_the_range
    assert_equal 6, MoviehouseUk::Performance.at('MH_COLE', from: DATE, to: DATE + 1).count
  end

  def test_at_sets_cinema_details
    performances = performances_at('MH_COLE')

    assert_equal ['MH_COLE'], performances.map(&:cinema_id).uniq
    assert_equal ['Coleraine'], performances.map(&:cinema_name).uniq
  end

  def test_at_parses_first_performance
    performance = performances_at('MH_COLE').first

    assert_equal 'Primetime', performance.film_name
    assert_nil performance.film_year
    assert_equal Time.utc(2026, 11, 1, 17, 0), performance.starting_at
    assert_equal '2d', performance.dimension
    assert_empty performance.variant
    assert_equal "#{TICKETS}97317", performance.booking_url
  end

  def test_unknown_venues_keep_the_website_booking_link
    performance = MoviehouseUk::Performance.new(
      booking_url: 'https://moviehouse.co.uk/newry/booking/123/film', cinema_id: 'MH_NEWR',
      cinema_name: 'Newry', film_name: 'Film', starting_at: Time.utc(2026, 11, 1)
    )

    assert_equal 'https://moviehouse.co.uk/newry/booking/123/film', performance.booking_url
  end

  def test_subtitled_screenings
    performances = on(DATE + 1)

    assert_equal [%w(subtitled)], performances.map(&:variant).uniq
  end

  def test_my_first_movie_screenings_are_for_kids
    performance = on(Date.new(2026, 11, 14)).first

    assert_equal 'My First Christmas Movie: Festive Fun with Peppa!', performance.film_name
    assert_equal %w(kids), performance.variant
  end

  def test_events_are_arts_whatever_their_heading
    events = performances_at('MH_COLE').select { |p| p.variant.include?('arts') }

    assert_equal [
      'National Theatre Live: Golden Boy',
      'Giant - The Play',
      "Andrew Lloyd Webber's Starlight Express",
      'Royal Ballet and Opera: The Nutcracker'
    ], events.map(&:film_name)
    assert_equal %w(arts subtitled), events[2].variant
  end

  def test_offers_are_not_variants
    performances = on(Date.new(2026, 11, 20))

    assert_equal 3, performances.count
    assert(performances.all? { |p| p.variant.empty? })
  end

  def test_last_date
    performance = performances_at('MH_COLE').last

    assert_equal Date.new(2026, 12, 1), performance.showing_on
    assert_equal Time.utc(2026, 12, 1, 19, 15), performance.starting_at
  end

  private

  def performances_at(cinema_id)
    MoviehouseUk::Performance.at(cinema_id, from: DATE, to: DATE + 365)
  end

  def on(date)
    MoviehouseUk::Performance.at('MH_COLE', from: date, to: date)
  end
end
