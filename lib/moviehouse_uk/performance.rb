module MoviehouseUk
  # A single screening of a film on the Movie House website
  class Performance < Cinebase::A1web::Performance
    # @!attribute [r] cinema_name
    #   @return [String] the cinema name
    # @!attribute [r] cinema_id
    #   @return [String] the cinema id
    # @!attribute [r] dimension
    #   @return [String] 2d or 3d
    # @!attribute [r] film_name
    #   @return [String] the film name

    # @!method initialize(options)
    #   @param [Hash] options options hash
    #   @option options [String] :booking_url (nil) buying url for the screening
    #   @option options [String] :cinema_name name of the cinema
    #   @option options [String] :cinema_id website id of the cinema
    #   @option options [String] :dimension ('2d') dimension of the screening
    #   @option options [Cinebase::Festival] :festival (nil) festival edition
    #   @option options [String] :film_name name of the film
    #   @option options [Integer] :film_year (nil) year from the film's title
    #   @option options [String] :language (nil) audio language, e.g. 'Polish'
    #   @option options [Time] :starting_at listed start time of the performance

    # @!method self.at(cinema_id, from: Date.today, to: from + 13)
    #   Performances within an inclusive range of showing dates, from one
    #   request: the venue's what's on page holds every advertised date.
    #   @param [String] cinema_id id of the cinema, e.g. 'MH_COLE'
    #   @param [Date] from first date (defaults to today in London)
    #   @param [Date] to last date (defaults to 13 days after from)
    #   @return [Array<MoviehouseUk::Performance>]

    # @!method showing_on
    #   The date of the screening
    #   @return [Date]

    # @!method starting_at
    #   UTC time of the screening
    #   @return [Time]

    # @!method variant
    #   The kinds of screening (arts, kids, subtitled ...)
    #   @return <Array[String]>

    # Movie House's group headings, beyond those A1Web chains share.
    # 'Film Performance TypeD' groups My First Movie screenings for young
    # children.
    VARIANTS = {
      'Event Recorded Performance' => 'arts',
      'Film Performance TypeD' => 'kids'
    }.freeze

    # Some events are listed under 'Subtitled' or under no heading at all
    EVENT = /\AEvent:/

    # Each venue's Admit One ticketing site
    TICKET_SITES = {
      'MH_BELF' => 'https://moviehousecityside.admit-one.co.uk',
      'MH_COLE' => 'https://moviehousecoleraine.admit-one.co.uk',
      'MH_GLEN' => 'https://moviehouseglengormley.admit-one.co.uk',
      'MH_MAGH' => 'https://moviehousemaghera.admit-one.co.uk'
    }.freeze

    PERF_CODE = %r{/booking/(\d+)/}

    # @api private
    def self.cinema_class
      Cinema
    end

    # @api private
    def self.title_sanitizer
      Internal::TitleSanitizer
    end

    # @api private
    def self.variants
      super.merge(VARIANTS)
    end

    def self.variant(showing)
      variant = super
      variant << 'arts' if showing.title.match?(EVENT)
      variant.uniq
    end
    private_class_method :variant

    # The website's own booking links only work in a browser that has
    # just visited the venue's pages, so link to the ticketing site, which
    # redirects to seat selection.
    # @return [String] e.g.
    #   'https://moviehousecoleraine.admit-one.co.uk/tickets/?perfCode=97317'
    def booking_url
      site = TICKET_SITES[cinema_id]
      code = super.to_s[PERF_CODE, 1]
      if site && code
        "#{site}/tickets/?perfCode=#{code}"
      else
        super
      end
    end
  end
end
