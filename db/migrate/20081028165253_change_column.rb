class ChangeColumn < ActiveRecord::Migration
  def self.up
    change_column :users, :stories, :text
  end

  def self.down
    remove_column :users, :stories, :text
  end
end
