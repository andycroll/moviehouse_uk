module MoviehouseUk
  # The object representing a cinema on the Movie House website
  class Cinema < Cinebase::A1web::Cinema
    # @!attribute [r] id
    #   @return [String] the A1Web site code of the cinema, e.g. 'MH_COLE'

    # @!method initialize(id)
    #   @param [String] id the cinema id, e.g. 'MH_COLE' or 'mh_cole'
    #   @return [MoviehouseUk::Cinema]

    # @!method self.all
    #   Return basic cinema information for all cinemas
    #   @return [Array<MoviehouseUk::Cinema>]
    #   @example
    #     MoviehouseUk::Cinema.all
    #     #=> [<MoviehouseUk::Cinema>, <MoviehouseUk::Cinema>, ...]

    # @!method adr
    #   Address of the cinema
    #   @return [Hash] contains :street_address, :extended_address,
    #   :locality, :region, :postal_code, :country_name
    #   @example
    #     cinema = MoviehouseUk::Cinema.new('MH_COLE')
    #     cinema.adr
    #     #=> {
    #           street_address:   '1 Riverside Park South',
    #           extended_address: nil,
    #           locality:         'Coleraine',
    #           region:           'County Londonderry',
    #           postal_code:      'BT51 3RT',
    #           country_name:     'United Kingdom'
    #         }
    #   @note Uses method naming as at http://microformats.org/wiki/adr

    # @!method latitude
    #   @return [Float, nil]

    # @!method longitude
    #   @return [Float, nil]

    # @!method name
    #   The name of the cinema
    #   @return [String]
    #   @example
    #     MoviehouseUk::Cinema.new('MH_BELF').name
    #     #=> 'CitySide Belfast'

    # @!method url
    #   The url of the cinema's pages on the Movie House website
    #   @return [String]
    #   @example
    #     MoviehouseUk::Cinema.new('MH_COLE').url
    #     #=> 'https://moviehouse.co.uk/coleraine'

    # The website gives no venue addresses. These come from the Food
    # Standards Agency's food hygiene ratings and coordinates from
    # OpenStreetMap.
    LOCATIONS = {
      'MH_BELF' => {
        street_address: 'CitySide Retail Park', extended_address: '100-150 York Street', locality: 'Belfast',
        region: 'County Antrim', postal_code: 'BT15 1WA', latitude: 54.6084736, longitude: -5.9270966
      },
      'MH_COLE' => {
        street_address: '1 Riverside Park South', locality: 'Coleraine', region: 'County Londonderry',
        postal_code: 'BT51 3RT', latitude: 55.1198699, longitude: -6.6780949
      },
      'MH_GLEN' => {
        street_address: '13-15 Glenwell Road', locality: 'Glengormley', region: 'County Antrim',
        postal_code: 'BT36 7RF', latitude: 54.6689259, longitude: -5.9570269
      },
      'MH_MAGH' => {
        street_address: '51 St Lurachs Road', locality: 'Maghera', region: 'County Londonderry',
        postal_code: 'BT46 5JE', latitude: 54.8440567, longitude: -6.6732007
      }
    }.freeze

    # @return [String]
    def self.website
      'https://moviehouse.co.uk'.freeze
    end

    # @api private
    def self.locations
      LOCATIONS
    end

    # Brand of the cinema
    # @return [String] which will always be 'Movie House'
    def brand
      'Movie House'.freeze
    end
  end
end
