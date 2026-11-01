require_relative '../../test_helper'

class MoviehouseUk::CinemaTest < Minitest::Test
  include WebsiteStubs

  IDS = %w(MH_BELF MH_COLE MH_GLEN MH_MAGH).freeze

  def setup
    stub_website
    MoviehouseUk::Cinema.instance_variable_set(:@venues_hash, nil)
  end

  def test_reads_moviehouse_co_uk
    assert_equal 'https://moviehouse.co.uk', MoviehouseUk::Cinema.client.base_url
  end

  def test_new_stores_upcase_string_id
    assert_equal 'MH_COLE', MoviehouseUk::Cinema.new('mh_cole').id
  end

  def test_all_returns_every_venue
    cinemas = MoviehouseUk::Cinema.all

    assert(cinemas.all? { |cinema| cinema.instance_of?(MoviehouseUk::Cinema) })
    assert_equal IDS, cinemas.map(&:id)
  end

  def test_all_reads_site_codes_from_venue_pages_once_an_hour
    2.times { MoviehouseUk::Cinema.all }

    assert_requested :get, HOME, times: 1
    VENUES.each { |venue| assert_requested :get, "#{HOME}#{venue}", times: 1 }
  end

  def test_name_full_name_and_slug
    cinema = MoviehouseUk::Cinema.new('MH_BELF')

    assert_equal 'CitySide Belfast', cinema.name
    assert_equal 'Movie House CitySide Belfast', cinema.full_name
    assert_equal 'movie-house-cityside-belfast', cinema.slug
  end

  def test_brand
    assert_equal 'Movie House', MoviehouseUk::Cinema.new('MH_COLE').brand
  end

  def test_url
    assert_equal COLERAINE, MoviehouseUk::Cinema.new('MH_COLE').url
  end

  def test_adr
    expected = {
      street_address:   '1 Riverside Park South',
      extended_address: nil,
      locality:         'Coleraine',
      region:           'County Londonderry',
      postal_code:      'BT51 3RT',
      country_name:     'United Kingdom'
    }

    assert_equal expected, MoviehouseUk::Cinema.new('MH_COLE').adr
  end

  def test_building_names_come_before_the_street
    cinema = MoviehouseUk::Cinema.new('MH_BELF')

    assert_equal 'CitySide Retail Park', cinema.street_address
    assert_equal '100-150 York Street', cinema.extended_address
  end

  def test_every_venue_has_a_postcode_and_coordinates
    MoviehouseUk::Cinema.all.each do |cinema|
      refute_empty cinema.locality, cinema.id
      assert_match(/\ABT\d{1,2} \d[A-Z]{2}\z/, cinema.postal_code, cinema.id)
      assert_kind_of Float, cinema.latitude, cinema.id
      assert_kind_of Float, cinema.longitude, cinema.id
    end
  end

  def test_unknown_cinema_has_no_location
    cinema = MoviehouseUk::Cinema.new('MH_ZZZZ')

    assert_equal '', cinema.name
    assert_nil cinema.latitude
  end
end
