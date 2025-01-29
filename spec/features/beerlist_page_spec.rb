# require 'rails_helper'
# require 'webdrivers/chromedriver'

# describe "Beerlist page" do
# 	before :all do
# 		# require 'webdrivers/chromedriver'
# 		# Selenium::WebDriver::Chrome.path = '/mnt/c/Windows/System32/chromedriver.exe'

# 		# Capybara.configure do |config|
# 		# 	config.default_driver = :selenium_chrome_headless
# 		#   end
# 		# Capybara.server_port = 9515

# 		Capybara.register_driver :chrome do |app|
# 			Capybara::Selenium::Driver.new app, browser: :chrome,
# 			  options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu])
# 		  end
# 		Selenium::WebDriver::Chrome.path = './chromedriver-linux64/chromedriver-linux64/chromedriver'

# 		Capybara.javascript_driver = :chrome
# 		# WebMock.disable_net_connect!(allow_localhost: true)
# 		WebMock.allow_net_connect!
# 	end

# 	before :each do
# 		@brewery1 = FactoryBot.create(:brewery, name: "Koff")
# 		@brewery2 = FactoryBot.create(:brewery, name: "Schlenkerla")
# 		@brewery3 = FactoryBot.create(:brewery, name: "Ayinger")
# 		@style1 = Style.create name: "Lager"
# 		@style2 = Style.create name: "Rauchbier"
# 		@style3 = Style.create name: "Weizen"
# 		@beer1 = FactoryBot.create(:beer, name: "Nikolai", brewery: @brewery1, style:@style1)
# 		@beer2 = FactoryBot.create(:beer, name: "Fastenbier", brewery:@brewery2, style:@style2)
# 		@beer3 = FactoryBot.create(:beer, name: "Lechte Weisse", brewery:@brewery3, style:@style3)
# 	end

# 	it "shows a known beer", :js => true do
# 		visit beerlist_path
# 		find('table').find('tr:nth-child(2)')
# 		save_and_open_page
# 		expect(page).to have_content "Nikolai"
# 	end


# end