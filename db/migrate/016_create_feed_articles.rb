class CreateFeedArticles < ActiveRecord::Migration
  def self.up
    create_table :feed_articles do |t|
      t.belongs_to :user
      t.string :feed_url
      t.text :feed_data
      t.timestamp :feed_updated_at

      t.timestamps
    end
    
    add_index :feed_articles, :user_id
  end

  def self.down
    drop_table :feed_articles
  end
end
