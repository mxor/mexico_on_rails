class CreateMessageCopies < ActiveRecord::Migration
  def self.up
    create_table :message_copies do |t|
      t.integer :recipient_id
      t.integer :message_id
      t.integer :folder_id
      t.boolean :deleted, :default => false

      t.timestamps
    end

    add_index :message_copies, :recipient_id
    add_index :message_copies, :message_id
    add_index :message_copies, :folder_id
  end

  def self.down
    drop_table :message_copies
  end
end
