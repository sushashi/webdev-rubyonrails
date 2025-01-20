class ConnectBeersStylesWithOldStyles < ActiveRecord::Migration[8.0]
  def up
    Beer.find_each do |beer|
      s = Style.find_by(name: beer.old_style)
      beer.update(style: s)
    end
  end

  def down
    Beer.update_all(style_id: nil)
  end
end
