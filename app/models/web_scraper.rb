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
    band_attribs[:band_id] = site.css("input[type=hidden]")[0].attributes["value"].value

    # Collect albums from page
    album_header = site.css("div#band_disco div[role]:nth-child(2) tr")[0].css("th").map {|e| e.text.downcase.to_sym}
    album_data = site.css("div#band_disco div[role]:nth-child(2) tr")[1..-1].map {|e| e.css("td").map {|el| el.text.squish}}
    album_hashes = album_data.map {|e| Hash[album_header.zip(e)]}
    band_attribs[:albums] = album_hashes.map {|album| Album.new(album)}

    # Collect members from page
    chunked_members_array = site.css("div#band_tab_members_all tr").slice_when { |i, j| j.attributes['class'].value == "lineupHeaders" }.to_a
    member_keys = [:status, :member_id, :name, :role, :associated_bands]
    member_statuses = chunked_members_array.map do |member|
      member.shift.text.squish
    end
    member_data = []
    chunked_members_array.each_with_index do |member_chunk_by_status, index|
      member_chunk_by_status.each do |member|
        if member.attributes['class'].value == 'lineupRow'
          member_data << member_statuses[index]
          member_data << member.css('a')[0].attributes['href'].value[29..-1]
          member_data << member.css('a')[0].text
          member_data << member.css('td')[-1].text.squish
        end
      end
    end
    member_keys.pop
    member_hashes = member_data.each_slice(4).map {|e| Hash[member_keys.zip(e)]}
    band_attribs[:members] = member_hashes.map {|member| Member.new(member)}
    band_attribs
  end

  def self.scrape_search_page(browser)
    site = Nokogiri::HTML(browser.html)
    band_keys = [:band_name, :genre, :country_of_origin, :band_id]
    band_values = site.css("table#searchResults tr")[1..-1].css("td").map {|e| e.text.squish}
    band_ids = site.css("table#searchResults tr")[1..-1].css("a").map{|e| e.attributes['href'].value[29..-1]}
    band_values = band_values.each_slice(3).to_a.each_with_index{|band, i| band << band_ids[i]}
    band_values.map {|e| Hash[band_keys.zip(e)]}
  end

end