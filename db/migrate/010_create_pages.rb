class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :title
      t.text :content
      t.boolean :published, :default => true
      t.integer :position
      t.string :permalink

      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
