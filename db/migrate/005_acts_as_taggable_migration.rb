class ActsAsTaggableMigration < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name
    end
    
    create_table :taggings do |t|
      t.integer :tag_id
      t.integer :taggable_id
      t.string :taggable_type
      
      t.datetime :created_at
    end

    add_column :articles, :cached_tag_list, :string
    add_index :taggings, :tag_id
    add_index :taggings, [:taggable_id, :taggable_type]
  end
  
  def self.down
    remove_column :articles, :cached_tag_list
    drop_table :taggings
    drop_table :tags
  end
end
