class AddNewstoriesToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :new_stories, :text
  end

  def self.down
    remove_column :users, :new_stories
  end
end
