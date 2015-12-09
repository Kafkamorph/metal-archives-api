class Album

  def initialize(args = {})
    @name = args.fetch(:name) {|e| "No #{e} found"}
    @type = args.fetch(:type) {|e| "No #{e} found"}
    @year = args.fetch(:year) {|e| "No #{e} found"}
    @reviews = args.fetch(:reviews) {|e| "No #{e} found"}

  end

end