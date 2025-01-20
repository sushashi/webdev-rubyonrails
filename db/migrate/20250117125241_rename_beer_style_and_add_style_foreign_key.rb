class RenameBeerStyleAndAddStyleForeignKey < ActiveRecord::Migration[8.0]
  def change
    rename_column :beers, :style, :old_style

    add_reference :beers, :style, foreign_key: true
  end
end
