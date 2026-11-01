require_relative 'live_helper'

class LiveIntegrationTest < Minitest::Test
  def test_cinemas_and_their_performances
    cinemas = MoviehouseUk::Cinema.all

    assert(cinemas.all? { |cinema| cinema.instance_of?(MoviehouseUk::Cinema) })
    assert_operator cinemas.size, :>=, 4
    assert_empty cinemas.map(&:id) - MoviehouseUk::Cinema::LOCATIONS.keys

    coleraine = cinemas.detect { |cinema| cinema.id == 'MH_COLE' }
    assert_equal 'Coleraine', coleraine.name

    today = Date.today
    performances = MoviehouseUk::Performance.at('MH_COLE', from: today, to: today + 365)

    assert(performances.all? { |p| p.instance_of?(MoviehouseUk::Performance) })
    assert_operator performances.count, :>, 50
    assert_operator performances.map(&:showing_on).max, :>, today + 7
    assert(performances.all? { |p| p.booking_url.match?(ApiShapes::BOOKING_URL) })
  end
end
