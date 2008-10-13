class AddStoriesColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :stories, :string
  end

  def self.down
    remove_column :users, :stories
  end
end
