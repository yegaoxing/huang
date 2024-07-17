class CreateWordlists < ActiveRecord::Migration[6.1]
  def change
    create_table :wordlists do |t|
      t.string :word
      t.string :reading

      t.timestamps
    end
  end
end
