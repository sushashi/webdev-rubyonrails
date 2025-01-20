class PlacesController < ApplicationController
	 before_action :set_place, only: %i[show]
	 def index
 	end

	 def show
 	end

	 def search
 		 @places = BeermappingApi.places_in(params[:city])
 		 # binding.pry
 		 if @places.empty?
   			redirect_to places_path, notice: "No places in #{params[:city]}"
   	else
 			  @weather = WeatherstackApi.get_weather_in(params[:city])

   			session[:last_city] = params[:city]
   			render :index, status: 418
    end

 		 # url = "https://studies.cs.helsinki.fi/beermapping/locations/"

 		 # response = HTTParty.get "#{url}#{ERB::Util.url_encode(params[:city])}"
 		 # places_from_api = response.parsed_response["bmp_locations"]["location"]

 		 # if places_from_api.is_a?(Hash) && places_from_api['id'].nil?
 		 # 	redirect_to places_path, notice: "No places in #{params[:city]}"
 		 # else
 		 # 	places_from_api = [places_from_api] if places_from_api.is_a?(Hash)
 		 # 	@places = places_from_api.map do |location|
 		 # 		Place.new(location)
 		 # 	end
 		 # 	render :index, status: 418
 		 # end

 		 # @places = response.parsed_response["bmp_locations"]["location"].map do |place|
 		 # 	Place.new(place)
 		 # end
 	end

	 def set_place
 		 # binding.pry
 		 @places = BeermappingApi.places_in(session[:last_city])
 		 @place = @places.find { |place| place.id == params.expect(:id) }
		  @weather_logo_url = WeatherstackApi.get_weather_in(session[:last_city])
 	end
end
