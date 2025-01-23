class AddClosedToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :closed, :boolean
  end
end
