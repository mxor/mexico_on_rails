class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :author_id
      t.string :subject
      t.text :body

      t.timestamps
    end

    add_index :messages, :author_id
  end

  def self.down
    drop_table :messages
  end
end
