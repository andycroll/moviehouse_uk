require_relative '../../../test_helper'

class MoviehouseUk::Internal::TitleSanitizerTest < Minitest::Test
  def test_plain_titles_are_unchanged
    assert_sanitized 'The Exorcist: Director\'s Cut', 'The Exorcist: Director\'s Cut'
    assert_sanitized 'Spider-Man: Brand New Day', 'Spider-Man: Brand New Day'
  end

  def test_event_prefix
    assert_sanitized 'Doctor Who: The Satan Pit', 'Event: Doctor Who: The Satan Pit'
    assert_sanitized 'Giant - The Play', 'Event: Giant - The Play'
  end

  def test_national_theatre_live
    assert_sanitized 'National Theatre Live: Golden Boy', 'Event: NTL Golden Boy'
  end

  def test_royal_ballet_and_opera
    assert_sanitized 'Royal Ballet and Opera: Carmen', 'Event: RBO Carmen'
    assert_sanitized 'Royal Ballet and Opera: The Nutcracker', 'Event: RBO The Nutcracker 2026'
    assert_sanitized 'Royal Ballet and Opera: Tosca', 'RBO 2026-27: Tosca'
  end

  def test_film_years
    assert_sanitized 'The Evil Dead', 'The Evil Dead (1981)'
  end

  private

  def assert_sanitized(expected, title)
    assert_equal expected, MoviehouseUk::Internal::TitleSanitizer.new(title).sanitized
  end
end
