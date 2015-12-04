require 'watir-webdriver'
require 'open-uri'

class BandNameController < ApplicationController

  def index
    search_url = "http://www.metal-archives.com/search?searchString=#{params[:band_name]}&type=band_name"

    browser = Watir::Browser.new :phantomjs
    browser.goto(search_url)

    ajax_call_hidden = browser.div(:class => "dataTables_processing").style("visibility" == "hidden")


    Watir::Wait.until { ajax_call_hidden }
    browser.driver.manage.timeouts.implicit_wait = 1
    site = Nokogiri::HTML(browser.html)
    band_content = browser.div(:id => "band_content")
    if band_content.present?
      binding.pry
    else
      band_table_rows = site.css("tr").to_a[1..-1]
      binding.pry
    end
  end

end