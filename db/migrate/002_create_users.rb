class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :login, :limit => 20
      t.string :name, :limit => 100
      t.string :email
      t.string :crypted_password, :limit => 40
      t.string :salt, :limit => 40
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at

      t.string :activation_code, :limit => 40
      t.datetime :activated_at
      t.string :reset_code, :limit => 40

      t.string :time_zone, :default => 'Mexico City'

      t.text :about
      t.string :weblog
      t.string :github
      t.string :wwr
      t.string :linkedin
      t.string :os
      t.string :text_editor
      t.string :msn
      t.string :public_email
      t.string :twitter
      
      t.boolean :admin, :default => false

      t.timestamps
    end

    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table :users
  end
end
