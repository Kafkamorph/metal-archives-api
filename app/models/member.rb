class Member

  attr_reader :status, :member_id, :name, :role, :bands

  def initialize(args = {})
    @status = args.fetch(:status){|e| "No #{e} found"}
    @member_id = args.fetch(:member_id){|e| "No #{e} found"}
    @name = args.fetch(:name){|e| "No #{e} found"}
    @role = args.fetch(:role){|e| "No #{e} found"}
    @associated_bands = args.fetch(:associated_bands){|e| "No #{e} found"}

  end

end