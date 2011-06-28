class HomeController < ApplicationController

  def index
    if (params[:lat] && params[:lng])
      render :json => Geocoder.search("#{params[:lat]}, #{params[:lng]}") 
    end
    if (params[:address])
      render :json => Geocoder.search(params[:address]) 
    end
  end


end
