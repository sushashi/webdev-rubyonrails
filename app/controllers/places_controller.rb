class PlacesController < ApplicationController
	 before_action :set_place, only: %i[show]
	 def index
 	end

	 def show
 	end

	 def search
 		 @places = BeermappingApi.places_in(params[:city])
 		 if @places.empty?
  			 redirect_to places_path, notice: "No places in #{params[:city]}"
  		else
  			 @weather = WeatherstackApi.get_weather_in(params[:city])

  		  session[:last_city] = params[:city]
  		  render :index, status: 418
  		end
 	end

	 def set_place
 		 @places = BeermappingApi.places_in(session[:last_city])
 		 @place = @places.find { |place| place.id == params.expect(:id) }
 		 @weather_logo_url = WeatherstackApi.get_weather_in(session[:last_city])
 	end
end
