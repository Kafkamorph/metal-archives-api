class Band

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
  end

end