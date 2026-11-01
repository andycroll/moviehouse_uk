require_relative 'fixtures_helper'

# Serve the fixtures in place of moviehouse.co.uk
module WebsiteStubs
  include FixturesHelper

  HOME = 'https://moviehouse.co.uk/'.freeze
  VENUES = %w(cityside-belfast coleraine glengormley maghera).freeze
  COLERAINE = 'https://moviehouse.co.uk/coleraine'.freeze

  private

  def stub_website
    stub_request(:get, HOME).to_return(status: 200, body: home_html)
    VENUES.each do |venue|
      stub_request(:get, "#{HOME}#{venue}").to_return(status: 200, body: venue_html(venue))
    end
    stub_request(:get, "#{COLERAINE}/whatson").to_return(status: 200, body: whats_on_html('MH_COLE'))
  end
end
