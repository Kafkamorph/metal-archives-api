# Metal Archives RestfulAPI

The [Encyclopaedia Metallum](http://www.metal-archives.com) is a valuable wealth of knowledge for heavy metal music.  The site has excessive details pertaining to an extreme amount bands.  But unfortunately there is no public API for people to access their data.  So I've decided to scrape the site and build a RESTful JSON API.

#### Routes

| HTTP Verb | URL                       |                                                                |
|-----------|---------------------------|----------------------------------------------------------------|
| GET       | /band_search/:band_name   | Search band name, return single band or array of similar bands |
| GET       | /band/:band_name/:band_id | Return single band                                             |

## This is a work in progress
Things currently being worked on:

  * Band show JSON returns members, but not their associated bands.  This is proving difficult because the status of their position in an associated band(ex, ex-live, live) is inline with the band and not separated out into it's own table data cell.  I may need to use regex to get around this problem.
  * Band show also returns albums and reviews count with the percentage, but not an id for the reviews with the actual review content.
  * Catching the Watir exception error while waiting for the AJAX call to respond on the website feels shaky.  I need to look into a better way around this.
  * Create routes and controllers for Albums, Members, Labels.  This can be implemented down the road after everything else is solidified.
  * Write rspec tests.
  * Create a root page explaining the API.
  * Deploy to AWS.