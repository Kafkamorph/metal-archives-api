class BandNameController < ApplicationController

  def index
    render :text => "#{params[:band_name]}"
  end

end