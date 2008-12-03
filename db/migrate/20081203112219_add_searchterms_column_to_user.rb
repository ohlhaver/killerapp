class AddSearchtermsColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :searchterms, :string
  end

  def self.down
    remove_column :users, :searchterms
  end
end
