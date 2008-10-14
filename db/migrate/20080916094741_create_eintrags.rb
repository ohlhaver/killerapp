class CreateEintrags < ActiveRecord::Migration
  def self.up
    create_table :eintrags do |t|
      t.string :name
      t.integer :duration
      t.timestamps
    end
  end

  def self.down
    drop_table :eintrags
  end
end
