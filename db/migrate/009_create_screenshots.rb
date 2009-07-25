class CreateScreenshots < ActiveRecord::Migration
  def self.up
    create_table :screenshots do |t|
      t.references :app
      t.integer :size
      t.string :content_type
      t.string :filename
      t.integer :height
      t.integer :width
      t.integer :parent_id
      t.string :thumbnail

      t.timestamps
    end

    add_index :screenshots, :app_id
  end

  def self.down
    drop_table :screenshots
  end
end
