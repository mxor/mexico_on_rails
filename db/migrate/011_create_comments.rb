class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.references :commentable, :polymorphic => true
      t.string :name
      t.string :email
      t.string :site_url
      t.text :content
      t.text :content_html
      t.string :user_ip
      t.string :user_agent
      t.string :referrer
      t.boolean :approved, :default => false, :null => false

      t.timestamps
    end

    add_index :comments, :commentable_id
  end

  def self.down
    drop_table :comments
  end
end
