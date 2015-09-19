class AddEnabledToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :enabled, :boolean
  end
end
