class CreateRepoFiles < ActiveRecord::Migration
  def change
    create_table :repo_files do |t|
      t.string :url
      t.string :access_key
      t.references :repository
      t.integer :version

      t.timestamps null: false
    end
  end
end
