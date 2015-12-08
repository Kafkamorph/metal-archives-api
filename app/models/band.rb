class Band

  def initialize(args = {})
    @band_name = args.fetch(:band_name)
    @country_of_origin = args.fetch(:country_of_origin)
    @location = args.fetch(:location)
    @status = args.fetch(:status)
    @formed_in = args.fetch(:formed_in)
    @genre = args.fetch(:genre)
    @lyrical_themes = args.fetch(:lyrical_themes)
    @current_label = args.fetch(:current_label)
    @years_active = args.fetch(:years_active)
    @band_name_img = args.fetch(:band_name_img)
    @band_img = args.fetch(:band_img)
    @albums = args.fetch(:albums)
    @members = args.fetch(:members)
  end

end