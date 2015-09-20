class AddFilenameToRepoFile < ActiveRecord::Migration
  def change
    add_column :repo_files, :filename, :string
  end
end
