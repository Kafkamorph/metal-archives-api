require 'watir-webdriver'
require 'open-uri'

class BandNameController < ApplicationController

  def index
    search_url = "http://www.metal-archives.com/search?searchString=#{params[:band_name]}&type=band_name"

    browser = Watir::Browser.new :phantomjs
    browser.goto(search_url)

    ajax_call_hidden = browser.div(class: "dataTables_processing").style("visibility" == "hidden")


    Watir::Wait.until { ajax_call_hidden }
    browser.driver.manage.timeouts.implicit_wait = 3
    site = Nokogiri::HTML(browser.html)
    band_content = browser.div(id: "band_content")
    if band_content.present?
      binding.pry
    else
      band_table_rows = site.css("tr").to_a[1..-1]
      binding.pry
      band_links = band_table_rows.each_with_object([]) do |table_row, ary|
        profile_link = table_row.elements[0].elements[0].attributes["href"].value
        ary << profile_link
        binding.pry
      end
      binding.pry
    end
  end
end