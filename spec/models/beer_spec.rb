require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "can be created and stored" do
    brewery = Brewery.new name:"Testbrewery", year: 2000
    style = Style.create name:"Lager", description: "Lager light"
    beer = Beer.create name:"Testbeer", style_id: style.id, brewery: brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "won't be created without a name" do
    brewery = Brewery.new name:"Testbrewery", year: 2000
    style = Style.new name:"Lager", description: "Lager light"
    beer = Beer.create style:style, brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "won't be created without a style" do
    brewery = Brewery.new name:"Testbrewery", year: 2000
    beer = Beer.create name:"TestBeer", brewery: brewery

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
