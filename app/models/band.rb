class Band
  attr_reader :band_name, :country_of_origin, :location, :status, :formed_in, :genre, :lyrical_themes, :current_label, :years_active, :band_name_img, :band_img, :albums, :members, :bio, :band_id

  def initialize(args = {})
    @band_name = args.fetch(:band_name) {|e| "No #{e} found"}
    @country_of_origin = args.fetch(:country_of_origin) {|e| "No #{e} found"}
    @location = args.fetch(:location) {|e| "No #{e} found"}
    @status = args.fetch(:status) {|e| "No #{e} found"}
    @formed_in = args.fetch(:formed_in) {|e| "No #{e} found"}
    @genre = args.fetch(:genre) {|e| "No #{e} found"}
    @lyrical_themes = args.fetch(:lyrical_themes) {|e| "No #{e} found"}
    @current_label = args.fetch(:current_label) {|e| "No #{e} found"}
    @years_active = args.fetch(:years_active) {|e| "No #{e} found"}
    @band_name_img = args.fetch(:band_name_img) {|e| "No #{e} found"}
    @band_img = args.fetch(:band_img) {|e| "No #{e} found"}
    @albums = args.fetch(:albums) {|e| "No #{e} found"}
    @members = args.fetch(:members) {|e| "No #{e} found"}
    @bio = args.fetch(:bio) {|e| "No #{e} found"}
    @band_id = args.fetch(:band_id) {|e| "No #{e} found"}
    @member_relationship_to_band = args.fetch(:member_relationship_to_band) {|e| "No #{e} found"}
  end

end