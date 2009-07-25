class CreateQuickTips < ActiveRecord::Migration
  def self.up
    create_table :quick_tips do |t|
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :quick_tips
  end
end
