class ChangeHaufens < ActiveRecord::Migration
 
    def self.up
      change_column :haufens, :members, :text
    end

    def self.down
      remove_column :haufens, :members, :text
    end
  end
