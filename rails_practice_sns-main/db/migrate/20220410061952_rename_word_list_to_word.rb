class RenameWordListToWord < ActiveRecord::Migration[6.1]
  def change
    rename_table :word_lists, :words
  end
end
