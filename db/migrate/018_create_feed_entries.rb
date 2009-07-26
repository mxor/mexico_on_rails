class CreateFeedEntries < ActiveRecord::Migration
  def self.up
    create_table :feed_entries do |t|
      t.string :author
      t.string :name
      t.text :summary
      t.string :url
      t.datetime :published_at
      t.string :guid

      t.timestamps
    end
    
    add_index :feed_entries, :guid
  end

  def self.down
    drop_table :feed_entries
  end
end
