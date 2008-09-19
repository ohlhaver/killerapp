class DropKings < ActiveRecord::Migration
  def self.up
    drop_table "kings"
  end

  def self.down
    create_table "kings"
  end
end
