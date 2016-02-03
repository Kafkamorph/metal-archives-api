
json.band_name @band.band_name
json.band_id @band.band_id
json.country_of_origin @band.country_of_origin
json.location @band.location
json.status @band.status
json.formed_in @band.formed_in
json.genre @band.genre
json.lyrical_themes @band.lyrical_themes
json.current_label @band.current_label
json.years_active @band.years_active
json.band_name_img @band.band_name_img
json.band_img @band.band_img
json.bio @band.bio
json.albums @band.albums
json.members @band.members.each do |m|
  json.name m.name
  json.member_id m.member_id
  json.role m.role
  json.status m.status
  if m.associated_bands.is_a?(Array)
    json.associated_bands m.associated_bands.each do |b|
      json.band_name b.band_name
      json.band_id b.band_id
      json.member_status b.member_relationship_to_band
    end
  end
end