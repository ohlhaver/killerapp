class AddLanguageColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :language, :integer
  end

  def self.down
    remove_column :users, :language
  end
end
