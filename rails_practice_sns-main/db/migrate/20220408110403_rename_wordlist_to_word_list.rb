class RenameWordlistToWordList < ActiveRecord::Migration[6.1]
  def change
    rename_table :wordlists, :word_lists
    add_column :word_lists, :user_id, :integer
  end
end
