class CreateFeedUrls < ActiveRecord::Migration
  def self.up
    create_table :feed_urls do |t|
      t.belongs_to :user
      t.string :url

      t.timestamps
    end
    
    add_index :feed_urls, :user_id
  end

  def self.down
    drop_table :feed_urls
  end
end
