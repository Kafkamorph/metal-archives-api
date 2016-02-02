class WebScraper

  def self.scrape_band_page(browser)
    if browser.link(:class, "btn_read_more").present?
      browser.link(:class, "btn_read_more").click
      sleep 1
    end
    site = Nokogiri::HTML(browser.html)

    band_attribs = self.collect_band_stats(site)

    band_attribs[:albums] = self.collect_albums_from_band_page(site)

    # Collect members from page
    member_keys = [:status, :member_id, :name, :role, :associated_bands]
    member_data = []
    if site.xpath("//div[@id='band_members']//tr").any? { |row| row.attributes["class"].value == "lineupHeaders" }
      chunked_members_array = site.css("div#band_tab_members_all tr").slice_when { |i, j| j.attributes['class'].value == "lineupHeaders" }.to_a
      member_statuses = chunked_members_array.map do |member|
        member.shift.text.squish
      end
      chunked_members_array.each_with_index do |member_chunk_by_status, index|
        member_chunk_by_status.each do |member|
          if member.attributes['class'].value == 'lineupRow'
            member_data << member_statuses[index]
            member_data << member.at_css('a').attributes['href'].value[29..-1]
            member_data << member.at_css('a').text
            member_data << member.css('td')[-1].text.squish
          elsif member.attributes['class'].value == 'lineupBandsRow'
            member_data << self.create_associated_bands(member)
          end
        end
      end

    else
      chunked_members_array = site.xpath("//div[@id='band_members']//tr").slice_when { |i, j| j.attributes['class'].value == "lineupRow" }.to_a
      member_status = site.at_xpath("//div[@id='band_members']//a").text
      chunked_members_array.each do |member_chunk|
        member_chunk.each do |member|
          if member.attributes['class'].value == 'lineupRow'
            member_data << member_status
            member_data << member.at_css('a').attributes['href'].value[29..-1]
            member_data << member.at_css('a').text
            member_data << member.css('td')[-1].text.squish
          end
        end
      end
    end
    # member_keys.pop
    member_hashes = member_data.each_slice(5).map { |e| Hash[member_keys.zip(e)] }
    band_attribs[:members] = member_hashes.map { |member| Member.new(member) }
    band_attribs
  end

  def self.create_associated_bands(member)
    associated_bands_array = member.text.squish.split(/:(.+)/)[1].split(',').map {|e| e[1..-1]}
    pattern = /\A(ex-)?(.*?)?(\(live\))?\z/
    final_ary = []
    associated_bands_array.each do |band_name|
      regexed_array = pattern.match(band_name).captures.map!(&:to_s)
      associated_band_attribs = Hash.new
      associated_band_attribs[:band_name] = regexed_array[1].squish
      band_with_links = member.css('a').select {|link| associated_band_attribs[:band_name] == link.text}
      unless band_with_links.empty?
        associated_band_attribs[:band_id] = band_with_links[0].attributes['href'].value[29..-1]
      end
      associated_band_attribs[:member_relationship_to_band] = regexed_array[0] + regexed_array[2]
      final_ary << Band.new(associated_band_attribs)
      # binding.pry

    end
    final_ary
  end
    # member.css('a').each do |band_link|
    #   associated_bands_array.delete_if do |band_name|
    #     if band_name.include? band_link.text
    #       final_ary << Band.new(band_name: band_name, band_id: band_link.attributes['href'].value[29..-1])
    #     else
    #       final_ary << Band.new(band_name: band_name)
    #       binding.pry
    #       # true
    #     end
    #     true
    #   end
    # end

  def self.scrape_search_page(browser)
    site = Nokogiri::HTML(browser.html)
    band_keys = [:band_name, :genre, :country_of_origin, :band_id]
    band_values = site.css("table#searchResults tr")[1..-1].css("td").map { |e| e.text.squish }
    band_ids = site.css("table#searchResults tr")[1..-1].css("a").map { |e| e.attributes['href'].value[29..-1] }
    band_values = band_values.each_slice(3).to_a.each_with_index { |band, i| band << band_ids[i] }
    band_values.map { |e| Hash[band_keys.zip(e)] }
  end

  def self.collect_band_stats(site)
    keys = site.css("div#band_stats dt").map { |e| e.text.chop.squish.downcase.tr(" ", "_").to_sym }
    values = site.css("div#band_stats dd").map { |e| e.text.squish }
    band_attribs = Hash[keys.zip values]
    band_attribs[:band_name] = site.at_css("h1.band_name a").text
    band_attribs[:band_name_img] = site.at_css("a#logo").attributes["href"].value
    band_attribs[:band_img] = site.at_css("a#photo").attributes["href"].value
    band_attribs[:bio] = site.at_css("div#readMoreDialog").text.squish
    band_attribs[:band_id] = site.at_css("input[type=hidden]").attributes["value"].value
    band_attribs
  end

  def self.collect_albums_from_band_page(site)
    album_header = site.at_css("div#band_disco div[role]:nth-child(2) tr").css("th").map { |e| e.text.downcase.to_sym }
    album_data = site.css("div#band_disco div[role]:nth-child(2) tr")[1..-1].map { |e| e.css("td").map { |el| el.text.squish } }
    album_hashes = album_data.map { |e| Hash[album_header.zip(e)] }
    album_hashes.map { |album| Album.new(album) }
  end

end