require 'watir-webdriver'
require 'open-uri'

class BandController < ApplicationController

  def index
    search_url = "http://www.metal-archives.com/search?searchString=#{params[:band_name]}&type=band_name"

    browser = Watir::Browser.new :phantomjs
    browser.goto(search_url)


    found = false
    count = 0
    until found || count > 4
      begin
        count += 1
        Watir::Wait.until { browser.div(id: "band_content").present? || browser.table(:id, 'searchResults').to_a[1..-1].length > 1 }
        found = true
       rescue Watir::Exception::UnknownObjectException
        puts "Saw error"
        sleep 1
       end
    end

    if found
      if browser.div(id: "band_content").present?
        band_attributes = WebScraper.scrape_band_page(browser)
        @band = Band.new(band_attributes)
        render :show
      elsif browser.table(id: "searchResults").present?
        bands_array = WebScraper.scrape_search_page(browser)
        @bands = bands_array.map {|band| Band.new(band)}
      else
        # return error message about band not in database
      end
    end
    browser.close
  end
end