class AddGhNameToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :gh_name, :string
  end
end
