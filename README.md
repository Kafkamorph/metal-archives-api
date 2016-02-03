# Metal Archives RestfulAPI

The [Encyclopaedia Metallum](http://www.metal-archives.com) is a valuable wealth of knowledge for heavy metal music.  The site has excessive details pertaining to an extreme amount bands.  But unfortunately there is no public API for people to access their data.  So I've decided to scrape the site and build a RESTful JSON API.

#### Routes

| HTTP Verb | URL                       |                                                                |
|-----------|---------------------------|----------------------------------------------------------------|
| GET       | /band_search/:band_name   | Search band name, return single band or array of similar bands |
| GET       | /bands/:band_name/:band_id | Return single band                                             |

## This is a work in progress
Things currently being worked on:

  * Found an occational bug when making calls to the API too quickly.  Seems like a Cacheing issue with the Watir browser?
  * Band show also returns albums and reviews count with the percentage, but not an id for the reviews with the actual review content.
  * Catching the Watir exception error while waiting for the AJAX call to respond on the website feels shaky.  I need to look into a better way around this.
  * Create routes and controllers for Albums, Members, Labels.  This can be implemented down the road after everything else is solidified.
  * Write rspec tests.
  * Create a root page explaining the API.
  * Deploy to AWS.