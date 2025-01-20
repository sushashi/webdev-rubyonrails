require 'rails_helper'

describe "Places" do
	it "if one is returned by the API, it is shown at the page" do
		allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
			[ Place.new(name: "Oljenjorsi", id: 1) ]
		)
		allow(WeatherstackApi).to receive(:get_weather_in).with("kumpula").and_return(
			{ "logo_link" => "url",
			"wind_speed" => 1,
			"wind_dir" => "NE",
			"temperature" => -3,
			"city" => "Kumpula"}
		)

		visit places_path
		fill_in("city", with: "kumpula")
		click_button "Search"

		expect(page).to have_content "Oljenjorsi"
	end

	it "if the API returns various beer restaurants, all of them are shown on the page" do
		allow(BeermappingApi).to receive(:places_in).with("cityname").and_return(
			[ Place.new(name: "AAA", id: 1), Place.new(name: "BBB", id: 2), Place.new(name: "CCC", id: 3) ]
		)
		allow(WeatherstackApi).to receive(:get_weather_in).with("cityname").and_return(
			{ "logo_link" => "url",
			"wind_speed" => 1,
			"wind_dir" => "NE",
			"temperature" => -3,
			"city" => "cityname"}
		)

		visit places_path
		fill_in("city", with: "cityname")
		click_button "Search"

		expect(page).to have_content "AAA"
		expect(page).to have_content "BBB"
		expect(page).to have_content "CCC"
	end

	it "No locations in place name" do
		allow(BeermappingApi).to receive(:places_in).with(any_args).and_return(
			[]
		)
		visit places_path
		fill_in("city", with: "cityname")
		click_button "Search"

		expect(page).to have_content "No places in cityname"
	end
end
