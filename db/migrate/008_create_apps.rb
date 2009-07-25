class CreateApps < ActiveRecord::Migration
  def self.up
    create_table :apps do |t|
      t.references :user
      t.string :name
      t.text :description
      t.string :site_url
      t.boolean :self_app, :default => false
      t.integer :comments_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :apps
  end
end
