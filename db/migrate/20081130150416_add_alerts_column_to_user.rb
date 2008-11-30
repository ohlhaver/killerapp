class AddAlertsColumnToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :alerts, :boolean
  end

  def self.down
    remove_column :users, :alerts
  end
end
