json.bands @bands do |band|
  json.band_name band.band_name
  json.country_of_origin band.country_of_origin
  json.genre band.genre
  json.band_id band.band_id
end