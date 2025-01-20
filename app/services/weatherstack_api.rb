class WeatherstackApi
  def self.get_weather_in(city)
    url = "http://api.weatherstack.com/current?"

    response = HTTParty.get "#{url}access_key=#{key}&query=#{ERB::Util.url_encode(city)}"
    # binding.pry
    # logo_link = response["current"]["weather_icons"].first
    # logo_link

    { "logo_link" => response["current"]["weather_icons"].first,
      "wind_speed" => response["current"]["wind_speed"],
      "wind_dir" => response["current"]["wind_dir"],
      "temperature" => response["current"]["temperature"],
      "city" => response["location"]["name"] }
  end

  def self.key

    return nil if Rails.env.test?
    raise "WEATHERSTACK_APIKEY env variable not defined" if ENV["WEATHERSTACK_APIKEY"].nil?

    ENV.fetch("WEATHERSTACK_APIKEY")
  end
end
