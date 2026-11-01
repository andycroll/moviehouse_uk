# MoviehouseUk

A simple gem to pull cinemas and performances from the [Movie House website](https://moviehouse.co.uk) and spit out useful formatted info.

## Installation

Add this line to your application's Gemfile:

    gem 'moviehouse_uk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moviehouse_uk

## Usage

The gem conforms to the API set down in the `cinebase` gem, [andycroll/cinebase](https://github.com/andycroll/cinebase), which provides a lot of useful base vocabulary and repetitive code for this series of cinema focussed gems.

Performance titles are sanitized as much as possible, removing the `Event:`
prefix, years and festival prefixes, and naming National Theatre Live and
Royal Ballet and Opera screenings in full.

No token or setup is needed. Movie House's website runs on Admit One's A1Web,
and cinebase's shared `Cinebase::A1web` support reads it. Each venue has its
own path, such as `https://moviehouse.co.uk/coleraine`, and sets its A1Web
site code on that page.

### Cinema

The venue list is cached for an hour. Reading it takes one request for the home
page and one for each venue's page. The website has no addresses or
coordinates, so the gem holds them: addresses from the Food Standards Agency's
food hygiene ratings and coordinates from OpenStreetMap.

``` ruby
MoviehouseUk::Cinema.all
#=> [<MoviehouseUk::Cinema ...>, <MoviehouseUk::Cinema ...>, ...]

cinema = MoviehouseUk::Cinema.new('MH_COLE')
#=> <MoviehouseUk::Cinema ...>

cinema.adr
#=> {
  street_address:   '1 Riverside Park South',
  extended_address: nil,
  locality:         'Coleraine',
  region:           'County Londonderry',
  postal_code:      'BT51 3RT',
  country_name:     'United Kingdom'
}

cinema.brand
#=> 'Movie House'

cinema.full_name
#=> 'Movie House Coleraine'

cinema.id
#=> 'MH_COLE'

cinema.latitude
#=> 55.1198699

cinema.url
#=> 'https://moviehouse.co.uk/coleraine'
```

### Performances

`Performance.at` returns performances for an inclusive range of showing dates,
defaulting to today in London and the following 13 days. The venue's what's on
page holds every advertised date, so any range is one request.

``` ruby
MoviehouseUk::Performance.at('MH_COLE', from: Date.today, to: Date.today + 2)
#=> [<MoviehouseUk::Performance ...>, <MoviehouseUk::Performance ...>, ...]

performance = MoviehouseUk::Performance.at('MH_COLE').first
#=> <MoviehouseUk::Performance ...>

performance.film_name
#=> 'National Theatre Live: Golden Boy' # from 'Event: NTL Golden Boy'

performance.film_year
#=> nil # from the title, e.g. 1981 for 'The Evil Dead (1981)'

performance.dimension
#=> '2d'

performance.variant
#=> ['arts']

performance.subtitled?
#=> false

performance.starting_at
#=> 2026-11-05 19:00:00 UTC

performance.booking_url
#=> 'https://moviehousecoleraine.admit-one.co.uk/tickets/?perfCode=90975'

performance.cinema_name
#=> 'Coleraine'

performance.cinema_id
#=> 'MH_COLE'
```

Booking links go to the venue's Admit One ticketing site, which redirects to
seat selection for the performance. The website's own booking links only work
in a browser that has just visited the venue's pages.

Variants are `arts` (recorded theatre, opera, ballet and other events), `kids`
(My First Movie screenings for young children) and `subtitled`.

## Tests

```sh
bundle exec rake          # unit tests against fixtures
bundle exec rake live     # live moviehouse.co.uk
```

Fixtures in `test/fixtures` are pages captured from moviehouse.co.uk: the home
page, each venue's page trimmed to its head, and the Coleraine what's on page
trimmed to a few films on a few dates. `test/support/api_shapes.rb` describes
the parts of the pages the gem reads. The unit suite checks the fixtures
against it and the live suite checks real responses, held only in memory. When
the website changes, update the shape first, then the fixtures.

## Releasing

Bump the version, merge, then run the **Release Gem** workflow in GitHub
Actions. It runs the tests, tags the version and publishes the gem through
RubyGems trusted publishing.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
