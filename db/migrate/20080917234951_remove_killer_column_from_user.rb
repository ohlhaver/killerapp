class RemoveKillerColumnFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :killer
  end

  def self.down
    remove_column :users, :killer
  end
end
