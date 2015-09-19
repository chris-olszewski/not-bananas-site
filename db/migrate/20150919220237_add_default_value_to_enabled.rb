class AddDefaultValueToEnabled < ActiveRecord::Migration
  def up
    change_column :repositories, :enabled, :boolean, :default => false, :null => false
  end
  def down
    change_column :repositories, :enabled, :boolean, :default => nil, :null => true
  end
end
