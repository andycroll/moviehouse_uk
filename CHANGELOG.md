# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [1.0.1] - 2026-11-01

### Fixed
- `Performance#booking_url` keeps a ticketing link it was given and stays nil when there is none, instead of returning a link with an empty `perfCode` or raising.

## [1.0.0] - 2026-11-01

### Added
- `MoviehouseUk::Cinema.all` and `MoviehouseUk::Cinema.new(id)` for Movie House's cinemas, from the cinema menu on the Movie House home page and the site code on each venue's page, with addresses from the Food Standards Agency's food hygiene ratings and coordinates from OpenStreetMap.
- `MoviehouseUk::Performance.at(id, from:, to:)`, from the venue's what's on page, which holds every advertised date, with booking links to each venue's Admit One ticketing site, variants for Movie House's group headings and events, and film years from titles, on cinebase 5.7's shared A1Web support.
- Fixtures trimmed from live pages, a live shape test that checks real responses without storing them, and GitHub Actions CI and release workflows.
