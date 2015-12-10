class WebScraper

  def self.scrape_band_page(browser)
    if browser.link(:class, "btn_read_more").present?
      browser.link(:class, "btn_read_more").click
      sleep 1
    end
    site = Nokogiri::HTML(browser.html)
    # Collect band statistics from page
    keys = site.css("div#band_stats dt").map {|e| e.text.chop.squish.downcase.tr(" ", "_").to_sym}
    values = site.css("div#band_stats dd").map {|e| e.text.squish}
    band_attribs = Hash[keys.zip values]
    band_attribs[:band_name] = site.css("h1.band_name a")[0].text
    band_attribs[:band_name_img] = site.css("a#logo")[0].attributes["href"].value
    band_attribs[:band_img] = site.css("a#photo")[0].attributes["href"].value
    band_attribs[:bio] = site.css("div#readMoreDialog")[0].text.squish
    band_attribs[:id] = site.css("input[type=hidden]")[0].attributes["value"].value

    # Collect albums from page
    album_header = site.css("div#band_disco div[role]:nth-child(2) tr")[0].css("th").map {|e| e.text.downcase.to_sym}
    album_data = site.css("div#band_disco div[role]:nth-child(2) tr")[1..-1].map {|e| e.css("td").map {|el| el.text.squish}}
    album_hashes = album_data.map {|e| Hash[album_header.zip(e)]}
    band_attribs[:albums] = album_hashes.map {|album| Album.new(album)}

    # Collect members from page
    chunked_members_array = site.css("div#band_tab_members_all tr").slice_when { |i, j| j.attributes['class'].value == "lineupHeaders" }.to_a

    band_attribs
  end

end