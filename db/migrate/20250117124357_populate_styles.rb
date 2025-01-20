class PopulateStyles < ActiveRecord::Migration[8.0]
  def up
    styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter", "Low alcohol"]

    styles.each do |s|
      Style.create!(name: s)
    end
  end

  def down
    Style.delete_all
  end
end
