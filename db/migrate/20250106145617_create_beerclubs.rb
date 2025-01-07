class CreateBeerclubs < ActiveRecord::Migration[8.0]
  def change
    create_table :beerclubs do |t|
      t.string :name
      t.integer :founded
      t.string :city

      t.timestamps
    end
  end
end
