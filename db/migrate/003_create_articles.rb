class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.references :user
      t.string :title
      t.text :excerpt
      t.text :body
      t.integer :level, :default => 0
      t.string :permalink
      t.integer :comments_count, :default => 0
      t.decimal :rating_average, :default => 0

      t.timestamps
    end

    add_index :articles, :permalink
  end

  def self.down
    drop_table :articles
  end
end
